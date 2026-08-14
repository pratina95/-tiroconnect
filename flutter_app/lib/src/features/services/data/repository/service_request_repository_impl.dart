import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/services/data/datasource/firestore_service_request_datasource.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'dart:developer' as developer;

@Injectable(as: ServiceRequestRepository)
class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final FirestoreServiceRequestDataSource _dataSource;

  ServiceRequestRepositoryImpl(this._dataSource);

  @override
  Future<ServiceRequestModel> createServiceRequest(
      ServiceRequestModel request) async {
    developer.log("REPOSITORY CALLED");
    return await _dataSource.createServiceRequest(request);
  }

  @override
  Future<List<ServiceRequestModel>> getServiceRequests({
    String? customerId,
    String? workerId,
    String? status,
  }) {
    return _dataSource.getServiceRequests(
      customerId: customerId,
      workerId: workerId,
      status: status,
    );
  }

  @override
  Future<ServiceRequestModel?> getServiceRequestById(String id) {
    return _dataSource.getServiceRequestById(id);
  }

  @override
  Future<void> updateServiceRequest(String id, Map<String, dynamic> data) {
    return _dataSource.updateServiceRequest(id, data);
  }

  @override
  Future<void> deleteServiceRequest(String id) {
    return _dataSource.deleteServiceRequest(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingRequests() {
    return _dataSource.getPendingRequests();
  }

  @override
  Future<List<ServiceRequestModel>> getWorkerJobs(String workerId) {
    return _dataSource.getServiceRequests(
      workerId: workerId,
    );
  }

  @override
  Future<List<ServiceRequestModel>> getAvailableJobs() {
    return _dataSource.getAvailableJobs();
  }
}
