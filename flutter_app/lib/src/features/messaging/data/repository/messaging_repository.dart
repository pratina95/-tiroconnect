import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/messaging/data/models/message_model.dart';

String buildConversationId({
  required String userAId,
  required String userBId,
  String? contextId,
}) {
  final ids = [userAId, userBId]..sort();
  final base = '${ids[0]}_${ids[1]}';
  if (contextId == null || contextId.trim().isEmpty) {
    return base;
  }
  return '$base::$contextId';
}

@lazySingleton
class MessagingRepository {
  final FirebaseFirestore _firestore;

  MessagingRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _conversations => _firestore
      .collection('conversations')
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data() ?? {},
        toFirestore: (data, _) => data,
      );

  CollectionReference<Map<String, dynamic>> _userConversationMemberships(
    String userId,
  ) {
    return _firestore
        .collection('user_conversations')
        .doc(userId)
        .collection('conversations');
  }

  /// Deterministic conversation ID for a pair of users, optionally scoped to a
  /// specific request/job context so different jobs do not share the same chat.
  String _conversationIdFor({
    required String userAId,
    required String userBId,
    String? contextId,
  }) {
    return buildConversationId(
      userAId: userAId,
      userBId: userBId,
      contextId: contextId,
    );
  }

  Future<String> resolveDisplayName({
    required String userId,
    String? fallback,
  }) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data();
      final fullName = data?['fullName'] as String?;
      if (fullName != null && fullName.trim().isNotEmpty) {
        return fullName.trim();
      }
    } catch (_) {}

    try {
      final customerDoc =
          await _firestore.collection('customers').doc(userId).get();
      final data = customerDoc.data();
      final customerName = data?['name'] as String?;
      if (customerName != null && customerName.trim().isNotEmpty) {
        return customerName.trim();
      }
    } catch (_) {}

    try {
      final workerDoc =
          await _firestore.collection('workers').doc(userId).get();
      final data = workerDoc.data();
      final workerName = data?['name'] as String?;
      if (workerName != null && workerName.trim().isNotEmpty) {
        return workerName.trim();
      }
    } catch (_) {}

    return fallback?.trim().isNotEmpty == true ? fallback!.trim() : 'User';
  }

  /// Finds an existing conversation between two users, or creates one.
  /// Returns the conversation ID.
  Future<String> getOrCreateConversation({
    required String userAId,
    required String userAName,
    required String userBId,
    required String userBName,
    String? contextId,
  }) async {
    final conversationId = _conversationIdFor(
      userAId: userAId,
      userBId: userBId,
      contextId: contextId,
    );
    String resolvedConversationId = conversationId;
    var docRef = _conversations.doc(conversationId);
    var conversationDoc = await docRef.get();

    if (!conversationDoc.exists) {
      for (final participantId in [userAId, userBId]) {
        final candidateSnapshot = await _conversations
            .where('participantIds', arrayContains: participantId)
            .get();

        for (final candidate in candidateSnapshot.docs) {
          final candidateIds = List<String>.from(
            candidate.data()['participantIds'] ?? const [],
          );
          final candidateContextId = candidate.data()['contextId']?.toString();
          final shouldReuseByParticipants =
              candidateIds.contains(userAId) && candidateIds.contains(userBId);
          final matchesContext = contextId == null || contextId.trim().isEmpty
              ? candidateContextId == null || candidateContextId.isEmpty
              : candidateContextId == contextId;

          if (shouldReuseByParticipants && matchesContext) {
            resolvedConversationId = candidate.id;
            docRef = _conversations.doc(resolvedConversationId);
            conversationDoc = await docRef.get();
            break;
          }
        }

        if (conversationDoc.exists) {
          break;
        }
      }
    }

    final resolvedUserAName = userAName.trim().isNotEmpty
        ? userAName.trim()
        : await resolveDisplayName(userId: userAId, fallback: 'User');
    final resolvedUserBName = userBName.trim().isNotEmpty
        ? userBName.trim()
        : await resolveDisplayName(userId: userBId, fallback: 'User');

    final participantIds = [userAId, userBId];
    final participantNames = {
      userAId: resolvedUserAName,
      userBId: resolvedUserBName,
    };

    final conversationData = {
      'participantIds': participantIds,
      'participantNames': participantNames,
      'contextId': contextId,
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (!conversationDoc.exists) {
      await docRef.set(conversationData);
    } else {
      await docRef.set(conversationData, SetOptions(merge: true));
    }

    await _upsertConversationMembership(
      conversationId: resolvedConversationId,
      userId: userAId,
      participantIds: participantIds,
      participantNames: participantNames,
      lastMessage: '',
    );
    await _upsertConversationMembership(
      conversationId: resolvedConversationId,
      userId: userBId,
      participantIds: participantIds,
      participantNames: participantNames,
      lastMessage: '',
    );

    return resolvedConversationId;
  }

  Future<void> _upsertConversationMembership({
    required String conversationId,
    required String userId,
    required List<String> participantIds,
    required Map<String, String> participantNames,
    required String lastMessage,
  }) async {
    await _userConversationMemberships(userId).doc(conversationId).set({
      'conversationId': conversationId,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'lastMessage': lastMessage,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Real-time stream of conversations a user is part of, most recent first.
  /// Uses explicit per-user memberships so the thread appears consistently for
  /// both participants after a request is accepted.
  Stream<List<ConversationModel>> streamConversations(String userId) {
    return _userConversationMemberships(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final conversations = snapshot.docs
          .map((doc) => ConversationModel.fromMap(
                id: doc.id,
                data: Map<String, dynamic>.from(doc.data()),
              ))
          .toList();

      if (conversations.isNotEmpty) {
        conversations.sort((a, b) {
          final aTime =
              a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime =
              b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });
        return conversations;
      }

      final legacySnapshot = await _conversations
          .where('participantIds', arrayContains: userId)
          .get();
      final legacyConversations = legacySnapshot.docs
          .map((doc) => ConversationModel.fromFirestore(doc))
          .toList();

      legacyConversations.sort((a, b) {
        final aTime = a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return legacyConversations;
    });
  }

  /// Fetches a single conversation once (not a stream) — useful for headers.
  Future<ConversationModel?> getConversation(String conversationId) async {
    final doc = await _conversations.doc(conversationId).get();
    if (!doc.exists) return null;
    return ConversationModel.fromFirestore(doc);
  }

  Future<String> resolveConversationTitle(
    String conversationId,
    String currentUserId,
  ) async {
    final conversation = await getConversation(conversationId);
    if (conversation == null) return 'Chat';

    final otherId = conversation.otherParticipantId(currentUserId);
    if (otherId.isEmpty) return 'Chat';

    final name = conversation.participantNames[otherId];
    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }

    final resolvedName = await resolveDisplayName(
      userId: otherId,
      fallback: 'User',
    );

    await _conversations.doc(conversationId).set(
      {
        'participantNames': {otherId: resolvedName},
      },
      SetOptions(merge: true),
    );

    return resolvedName;
  }

  /// Real-time stream of messages in a conversation, oldest first.
  Stream<List<MessageModel>> streamMessages(String conversationId) {
    return _conversations
        .doc(conversationId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      final messages =
          snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();

      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return messages;
    });
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final conversationRef = _conversations.doc(conversationId);

    await conversationRef.collection('messages').add({
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });

    await conversationRef.update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastMessageSenderId': senderId,
    });

    final conversationDoc = await conversationRef.get();
    final participantIds = List<String>.from(
      conversationDoc.data()?['participantIds'] ?? const [],
    );
    final participantNames = Map<String, String>.from(
      conversationDoc.data()?['participantNames'] ?? const {},
    );

    for (final participantId in participantIds) {
      await _userConversationMemberships(participantId)
          .doc(conversationId)
          .set({
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
        'participantIds': participantIds,
        'participantNames': participantNames,
      }, SetOptions(merge: true));
    }

    final notificationId =
        '${DateTime.now().millisecondsSinceEpoch}_$conversationId';
    final recipientIds = participantIds.where((id) => id != senderId).toList();
    for (final recipientId in recipientIds) {
      await _firestore
          .collection('notifications')
          .doc('${notificationId}_$recipientId')
          .set({
        'id': '${notificationId}_$recipientId',
        'userId': recipientId,
        'title': 'New message',
        'message': text,
        'requestId': conversationId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
