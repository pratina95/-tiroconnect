import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';

abstract class ServiceRequestRepository {
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
  Future<List<ServiceRequestModel>> getWorkerJobs(String workerId);
  Future<List<ServiceRequestModel>> getAvailableJobs();
}
