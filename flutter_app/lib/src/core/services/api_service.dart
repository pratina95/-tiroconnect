import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> getUserProfile(String id) async {
    final response = await _dio.get('/users/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> registerCustomer(
      Map<String, dynamic> body) async {
    final response = await _dio.post('/auth/register/customer', data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> registerWorker(Map<String, dynamic> body) async {
    final response = await _dio.post('/auth/register/worker', data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> registerBusiness(
      Map<String, dynamic> body) async {
    final response = await _dio.post('/auth/register/business', data: body);
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _dio.get('/categories');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getWorkers({
    double? lat,
    double? lng,
    double? radius,
    List<String>? skills,
    double? minRating,
    bool? isAvailable,
  }) async {
    final response = await _dio.get('/workers', queryParameters: {
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'skills': skills,
      'minRating': minRating,
      'isAvailable': isAvailable,
    });
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getJobs({
    double? lat,
    double? lng,
    double? radius,
    String? category,
    String? status,
  }) async {
    final response = await _dio.get('/jobs', queryParameters: {
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'category': category,
      'status': status,
    });
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createJob(Map<String, dynamic> body) async {
    final response = await _dio.post('/jobs', data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> getJob(String id) async {
    final response = await _dio.get('/jobs/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> applyForJob(
      String id, Map<String, dynamic> body) async {
    final response = await _dio.post('/jobs/$id/apply', data: body);
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final response = await _dio.get('/messages/$conversationId');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body) async {
    final response = await _dio.post('/messages', data: body);
    return response.data;
  }

  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> body) async {
    final response = await _dio.post('/payments', data: body);
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    final response = await _dio.get('/payments/history');
    return (response.data as List).cast<Map<String, dynamic>>();
  }
}
