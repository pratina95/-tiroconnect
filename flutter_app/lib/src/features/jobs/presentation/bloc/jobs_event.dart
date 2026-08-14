part of 'jobs_bloc.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object> get props => [];
}

class LoadJobs extends JobsEvent {
  final double? lat;
  final double? lng;
  final double? radius;
  final String? category;
  final String? status;

  const LoadJobs({
    this.lat,
    this.lng,
    this.radius,
    this.category,
    this.status,
  });

  @override
  List<Object> get props =>
      [lat ?? '', lng ?? '', radius ?? '', category ?? '', status ?? ''];
}

class CreateJob extends JobsEvent {
  final String title;
  final String description;
  final String categoryId;
  final double budget;
  final bool isNegotiable;
  final String location;
  final DateTime? date;
  final TimeOfDay? time;
  final String urgency;

  const CreateJob({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.budget,
    required this.isNegotiable,
    required this.location,
    this.date,
    this.time,
    required this.urgency,
  });

  @override
  List<Object> get props => [
        title,
        description,
        categoryId,
        budget,
        isNegotiable,
        location,
        urgency,
      ];
}

class ApplyForJob extends JobsEvent {
  final String jobId;
  final double quotationAmount;
  final String? message;

  const ApplyForJob({
    required this.jobId,
    required this.quotationAmount,
    this.message,
  });

  @override
  List<Object> get props => [jobId, quotationAmount];
}

class UpdateJobStatus extends JobsEvent {
  final String jobId;
  final String status;

  const UpdateJobStatus({
    required this.jobId,
    required this.status,
  });

  @override
  List<Object> get props => [jobId, status];
}
