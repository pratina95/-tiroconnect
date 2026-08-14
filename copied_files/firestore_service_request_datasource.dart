import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';

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
    print("TEST START");

    // Test Firestore directly
    try {
      print("FIRESTORE WRITE START");
      final result = await FirebaseFirestore.instance
          .collection("test")
          .add({"hello": "world", "time": Timestamp.now()})
          .timeout(const Duration(seconds: 10));
      print("DOCUMENT ID: ${result.id}");
      print("FIRESTORE WRITE SUCCESS");
    } catch (e, s) {
      print("FIRESTORE ERROR: $e");
      print("FIRESTORE STACK: $s");
    }

    print("DATASOURCE CALLED");
    print("REQUEST JSON: ${request.toJson()}");
    try {
      print("About to write...");
      final docRef = _firestore.collection(_collection).doc(request.id);
      await docRef.set(request.toJson());
      print("Write completed");
      print("SERVICE SAVED SUCCESSFULLY");
      return request;
    } on FirebaseException catch (e) {
      print("========== FIREBASE EXCEPTION ==========");
      print("Firebase Code: ${e.code}");
      print("Firebase Message: ${e.message}");
      print("Firebase Plugin: ${e.plugin}");
      rethrow;
    } catch (e, s) {
      print("========== OTHER ERROR ==========");
      print(e);
      print(s);
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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('service_requests')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

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
          'updatedAt':
              data['updatedAt'] != null && data['updatedAt'] is Timestamp
              ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
              : data['updatedAt'],
        };
      }).toList();
    } catch (e) {
      print("GET REQUESTS ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<List<ServiceRequestModel>> getAvailableJobs() async {
    print("===== CHECKING AVAILABLE JOBS =====");

    final snapshot = await FirebaseFirestore.instance
        .collection('service_requests')
        .get();

    print("TOTAL REQUESTS: ${snapshot.docs.length}");

    for (var doc in snapshot.docs) {
      print("DOCUMENT ID: ${doc.id}");
      print(doc.data());
    }

    final pending = snapshot.docs.where((doc) {
      final data = doc.data();
      return data['status'] == 'pending' && data['workerId'] == null;
    }).toList();

    print("AVAILABLE COUNT: ${pending.length}");

    return pending.map((doc) {
      return ServiceRequestModel.fromJson(doc.data());
    }).toList();
  }
}
