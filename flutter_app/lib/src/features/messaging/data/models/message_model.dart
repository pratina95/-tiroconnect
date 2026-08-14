import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool read;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.read = false,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      read: data['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'read': read,
    };
  }
}

class ConversationModel {
  final String id;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final String lastMessage;
  final DateTime? lastMessageAt;

  ConversationModel({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    required this.lastMessage,
    this.lastMessageAt,
  });

  factory ConversationModel.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return ConversationModel(
      id: id,
      participantIds: List<String>.from(data['participantIds'] ?? const []),
      participantNames:
          Map<String, String>.from(data['participantNames'] ?? const {}),
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ConversationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversationModel.fromMap(id: doc.id, data: data);
  }

  /// Returns the display name of the other person in this conversation,
  /// given the current user's ID.
  String otherParticipantName(String currentUserId) {
    final otherId = participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    if (otherId.isEmpty) return 'User';

    final name = participantNames[otherId];
    if (name != null && name.trim().isNotEmpty) {
      return name;
    }

    final fallbackName = participantNames.values
        .firstWhere((n) => n.trim().isNotEmpty, orElse: () => 'User');
    return fallbackName;
  }

  String otherParticipantId(String currentUserId) {
    return participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }
}
