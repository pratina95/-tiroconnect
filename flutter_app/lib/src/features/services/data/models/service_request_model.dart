import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_request_model.g.dart';

enum ServiceRequestStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled
}

@JsonSerializable()
class ServiceRequestModel extends Equatable {
  final String id;
  final String customerId;
  final String? workerId;
  final String category;
  final String service;
  final String? pages;
  final String location;
  final String description;
  final String urgency;
  final ServiceRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ServiceRequestModel({
    required this.id,
    required this.customerId,
    this.workerId,
    required this.category,
    required this.service,
    this.pages,
    required this.location,
    required this.description,
    required this.urgency,
    this.status = ServiceRequestStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceRequestModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        customerId,
        workerId,
        category,
        service,
        pages,
        location,
        description,
        urgency,
        status,
        createdAt,
        updatedAt,
      ];
}
