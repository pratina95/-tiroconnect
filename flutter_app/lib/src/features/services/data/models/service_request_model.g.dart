// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequestModel _$ServiceRequestModelFromJson(Map<String, dynamic> json) =>
    ServiceRequestModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      workerId: json['workerId'] as String?,
      category: json['category'] as String,
      service: json['service'] as String,
      pages: json['pages'] as String?,
      location: json['location'] as String,
      description: json['description'] as String,
      urgency: json['urgency'] as String,
      status:
          $enumDecodeNullable(_$ServiceRequestStatusEnumMap, json['status']) ??
              ServiceRequestStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceRequestModelToJson(
        ServiceRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'workerId': instance.workerId,
      'category': instance.category,
      'service': instance.service,
      'pages': instance.pages,
      'location': instance.location,
      'description': instance.description,
      'urgency': instance.urgency,
      'status': _$ServiceRequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ServiceRequestStatusEnumMap = {
  ServiceRequestStatus.pending: 'pending',
  ServiceRequestStatus.accepted: 'accepted',
  ServiceRequestStatus.inProgress: 'inProgress',
  ServiceRequestStatus.completed: 'completed',
  ServiceRequestStatus.cancelled: 'cancelled',
};
