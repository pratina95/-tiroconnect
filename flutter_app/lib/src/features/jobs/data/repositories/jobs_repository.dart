import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/core/services/api_service.dart';
import 'package:tiroconnect/src/features/jobs/data/models/job_model.dart';

abstract class JobsRepository {
  Future<List<JobModel>> getJobs({
    double? lat,
    double? lng,
    double? radius,
    String? category,
    String? status,
  });

  Future<JobModel> createJob({
    required String title,
    required String description,
    required String categoryId,
    required double budget,
    required bool isNegotiable,
    required String location,
    DateTime? date,
    TimeOfDay? time,
    required String urgency,
  });

  Future<void> applyForJob({
    required String jobId,
    required double quotationAmount,
    String? message,
  });

  Future<void> updateJobStatus({
    required String jobId,
    required String status,
  });
}

@LazySingleton(as: JobsRepository)
class JobsRepositoryImpl implements JobsRepository {
  final ApiService _apiService;

  JobsRepositoryImpl(this._apiService);

  @override
  Future<List<JobModel>> getJobs({
    double? lat,
    double? lng,
    double? radius,
    String? category,
    String? status,
  }) async {
    final response = await _apiService.getJobs(
      lat: lat,
      lng: lng,
      radius: radius,
      category: category,
      status: status,
    );
    return response.map((json) => JobModel.fromJson(json)).toList();
  }

  @override
  Future<JobModel> createJob({
    required String title,
    required String description,
    required String categoryId,
    required double budget,
    required bool isNegotiable,
    required String location,
    DateTime? date,
    TimeOfDay? time,
    required String urgency,
  }) async {
    final response = await _apiService.createJob({
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'budget': budget,
      'isNegotiable': isNegotiable,
      'locationAddress': location,
      'scheduledDate': date?.toIso8601String(),
      'scheduledTime': time != null ? '${time.hour}:${time.minute}' : null,
      'urgency': urgency,
    });
    return JobModel.fromJson(response);
  }

  @override
  Future<void> applyForJob({
    required String jobId,
    required double quotationAmount,
    String? message,
  }) async {
    await _apiService.applyForJob(jobId, {
      'quotationAmount': quotationAmount,
      'message': message,
    });
  }

  @override
  Future<void> updateJobStatus({
    required String jobId,
    required String status,
  }) async {
    // This would be implemented in the API
  }
}
