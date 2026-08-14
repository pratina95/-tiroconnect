// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      workerId: json['workerId'] as String?,
      categoryId: json['categoryId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      budget: (json['budget'] as num).toDouble(),
      isNegotiable: json['isNegotiable'] as bool? ?? true,
      locationAddress: json['locationAddress'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      scheduledDate: json['scheduledDate'] == null
          ? null
          : DateTime.parse(json['scheduledDate'] as String),
      scheduledTime: json['scheduledTime'] as String?,
      urgency: $enumDecodeNullable(_$JobUrgencyEnumMap, json['urgency']) ??
          JobUrgency.normal,
      requiredSkills: (json['requiredSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$JobStatusEnumMap, json['status']) ??
          JobStatus.open,
      aiMatchingScore: (json['aiMatchingScore'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'workerId': instance.workerId,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'videos': instance.videos,
      'budget': instance.budget,
      'isNegotiable': instance.isNegotiable,
      'locationAddress': instance.locationAddress,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'scheduledDate': instance.scheduledDate?.toIso8601String(),
      'scheduledTime': instance.scheduledTime,
      'urgency': _$JobUrgencyEnumMap[instance.urgency]!,
      'requiredSkills': instance.requiredSkills,
      'status': _$JobStatusEnumMap[instance.status]!,
      'aiMatchingScore': instance.aiMatchingScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$JobUrgencyEnumMap = {
  JobUrgency.low: 'low',
  JobUrgency.normal: 'normal',
  JobUrgency.high: 'high',
  JobUrgency.emergency: 'emergency',
};

const _$JobStatusEnumMap = {
  JobStatus.open: 'open',
  JobStatus.inProgress: 'inProgress',
  JobStatus.completed: 'completed',
  JobStatus.cancelled: 'cancelled',
};

JobApplicationModel _$JobApplicationModelFromJson(Map<String, dynamic> json) =>
    JobApplicationModel(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      workerId: json['workerId'] as String,
      quotationAmount: (json['quotationAmount'] as num).toDouble(),
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JobApplicationModelToJson(
        JobApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'workerId': instance.workerId,
      'quotationAmount': instance.quotationAmount,
      'message': instance.message,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
