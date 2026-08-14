import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

enum JobStatus { open, inProgress, completed, cancelled }

enum JobUrgency { low, normal, high, emergency }

@JsonSerializable()
class JobModel extends Equatable {
  final String id;
  final String customerId;
  final String? workerId;
  final String? categoryId;
  final String title;
  final String description;
  final List<String> images;
  final List<String> videos;
  final double budget;
  final bool isNegotiable;
  final String? locationAddress;
  final double? locationLat;
  final double? locationLng;
  final DateTime? scheduledDate;
  final String? scheduledTime;
  final JobUrgency urgency;
  final List<String> requiredSkills;
  final JobStatus status;
  final double? aiMatchingScore;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const JobModel({
    required this.id,
    required this.customerId,
    this.workerId,
    this.categoryId,
    required this.title,
    required this.description,
    this.images = const [],
    this.videos = const [],
    required this.budget,
    this.isNegotiable = true,
    this.locationAddress,
    this.locationLat,
    this.locationLng,
    this.scheduledDate,
    this.scheduledTime,
    this.urgency = JobUrgency.normal,
    this.requiredSkills = const [],
    this.status = JobStatus.open,
    this.aiMatchingScore,
    required this.createdAt,
    this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        customerId,
        workerId,
        categoryId,
        title,
        description,
        images,
        videos,
        budget,
        isNegotiable,
        locationAddress,
        locationLat,
        locationLng,
        scheduledDate,
        scheduledTime,
        urgency,
        requiredSkills,
        status,
        aiMatchingScore,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class JobApplicationModel extends Equatable {
  final String id;
  final String jobId;
  final String workerId;
  final double quotationAmount;
  final String? message;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const JobApplicationModel({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.quotationAmount,
    this.message,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobApplicationModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        jobId,
        workerId,
        quotationAmount,
        message,
        status,
        createdAt,
        updatedAt,
      ];
}
