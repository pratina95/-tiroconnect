part of 'jobs_bloc.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object> get props => [];
}

class JobsInitial extends JobsState {
  const JobsInitial();
}

class JobsLoading extends JobsState {
  const JobsLoading();
}

class JobsLoaded extends JobsState {
  final List<JobModel> jobs;

  const JobsLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

class JobCreated extends JobsState {
  final JobModel job;

  const JobCreated(this.job);

  @override
  List<Object> get props => [job];
}

class JobApplicationSubmitted extends JobsState {
  const JobApplicationSubmitted();
}

class JobStatusUpdated extends JobsState {
  const JobStatusUpdated();
}

class JobsError extends JobsState {
  final String message;

  const JobsError(this.message);

  @override
  List<Object> get props => [message];
}
