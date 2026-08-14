import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'dart:developer' as developer;

abstract class ServiceRequestDataSource {
  Future<ServiceRequestModel> createServiceRequest(ServiceRequestModel request);
  Future<List<ServiceRequestModel>> getServiceRequests({
    String? customerId,
    String? workerId,
    String? status,
  });
  Future<ServiceRequestModel?> getServiceRequestById(String id);
  Future<void> updateServiceRequest(String id, Map<String, dynamic> data);
  Future<void> deleteServiceRequest(String id);
  Future<List<Map<String, dynamic>>> getPendingRequests();
  Future<List<ServiceRequestModel>> getAvailableJobs();
}

@lazySingleton
class FirestoreServiceRequestDataSource implements ServiceRequestDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'service_requests';

  @override
  Future<ServiceRequestModel> createServiceRequest(
    ServiceRequestModel request,
  ) async {
    developer.log("TEST START");

    // Test Firestore directly
    try {
      developer.log("FIRESTORE WRITE START");
      final result = await FirebaseFirestore.instance
          .collection("test")
          .add({"hello": "world", "time": Timestamp.now()}).timeout(
              const Duration(seconds: 10));
      developer.log("DOCUMENT ID: ${result.id}");
      developer.log("FIRESTORE WRITE SUCCESS");
    } catch (e, s) {
      developer.log("FIRESTORE ERROR: $e", error: e, stackTrace: s);
    }

    developer.log("DATASOURCE CALLED");
    developer.log("REQUEST JSON: ${request.toJson()}");
    try {
      developer.log("About to write...");
      final docRef = _firestore.collection(_collection).doc(request.id);
      await docRef.set(request.toJson());
      developer.log("Write completed");
      developer.log("SERVICE SAVED SUCCESSFULLY");
      return request;
    } on FirebaseException catch (e) {
      developer.log("========== FIREBASE EXCEPTION ==========");
      developer.log("Firebase Code: ${e.code}");
      developer.log("Firebase Message: ${e.message}");
      developer.log("Firebase Plugin: ${e.plugin}");
      rethrow;
    } catch (e, s) {
      developer.log("========== OTHER ERROR ==========", error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<ServiceRequestModel>> getServiceRequests({
    String? customerId,
    String? workerId,
    String? status,
  }) async {
    Query query = _firestore.collection(_collection);

    if (customerId != null) {
      query = query.where('customerId', isEqualTo: customerId);
    }
    if (workerId != null) {
      query = query.where('workerId', isEqualTo: workerId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ServiceRequestModel(
        id: doc.id,
        customerId: data['customerId'] ?? '',
        workerId: data['workerId'],
        category: data['category'] ?? '',
        service: data['service'] ?? '',
        location: data['location'] ?? '',
        description: data['description'] ?? '',
        urgency: data['urgency'] ?? 'normal',
        status: _parseStatus(data['status']),
        createdAt: data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.parse(
                data['createdAt'] as String? ??
                    DateTime.now().toIso8601String(),
              ),
        updatedAt: data['updatedAt'] != null && data['updatedAt'] is Timestamp
            ? (data['updatedAt'] as Timestamp).toDate()
            : data['updatedAt'] is String
                ? DateTime.parse(data['updatedAt'] as String)
                : null,
      );
    }).toList();
  }

  ServiceRequestStatus _parseStatus(dynamic status) {
    if (status is String) {
      return ServiceRequestStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ServiceRequestStatus.pending,
      );
    }
    return ServiceRequestStatus.pending;
  }

  @override
  Future<ServiceRequestModel?> getServiceRequestById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return ServiceRequestModel(
        id: doc.id,
        customerId: data['customerId'] ?? '',
        workerId: data['workerId'],
        category: data['category'] ?? '',
        service: data['service'] ?? '',
        location: data['location'] ?? '',
        description: data['description'] ?? '',
        urgency: data['urgency'] ?? 'normal',
        status: _parseStatus(data['status']),
        createdAt: data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.parse(
                data['createdAt'] as String? ??
                    DateTime.now().toIso8601String(),
              ),
        updatedAt: data['updatedAt'] != null && data['updatedAt'] is Timestamp
            ? (data['updatedAt'] as Timestamp).toDate()
            : data['updatedAt'] is String
                ? DateTime.parse(data['updatedAt'] as String)
                : null,
      );
    }
    return null;
  }

  @override
  Future<void> updateServiceRequest(
    String id,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(_collection).doc(id).update(data);
  }

  @override
  Future<void> deleteServiceRequest(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    developer.log("========== GET PENDING REQUESTS ==========");

    final snapshot = await FirebaseFirestore.instance
        .collection('service_requests')
        .where('status', isEqualTo: 'pending')
        .get();

    developer.log("Documents found: ${snapshot.docs.length}");

    for (final doc in snapshot.docs) {
      developer.log(doc.data().toString());
    }

    developer.log("=========================================");

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'customerId': data['customerId'],
        'workerId': data['workerId'],
        'category': data['category'],
        'service': data['service'],
        'location': data['location'],
        'description': data['description'],
        'urgency': data['urgency'],
        'status': data['status'],
        'createdAt': data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).toDate().toIso8601String()
            : data['createdAt'],
        'updatedAt': data['updatedAt'] != null && data['updatedAt'] is Timestamp
            ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
            : data['updatedAt'],
      };
    }).toList();
  }

  @override
  Future<List<ServiceRequestModel>> getAvailableJobs() async {
    developer.log("===== CHECKING AVAILABLE JOBS =====");

    final snapshot =
        await FirebaseFirestore.instance.collection('service_requests').get();

    developer.log("TOTAL REQUESTS: ${snapshot.docs.length}");

    for (var doc in snapshot.docs) {
      developer.log("DOCUMENT ID: ${doc.id}");
      developer.log(doc.data().toString());
    }

    final pending = snapshot.docs.where((doc) {
      final data = doc.data();
      return data['status'] == 'pending' && data['workerId'] == null;
    }).toList();

    developer.log("AVAILABLE COUNT: ${pending.length}");

    return pending.map((doc) {
      return ServiceRequestModel.fromJson(doc.data());
    }).toList();
  }
}
