import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/jobs/data/models/job_model.dart';
import 'package:tiroconnect/src/features/jobs/data/repositories/jobs_repository.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

@LazySingleton()
class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final JobsRepository _jobsRepository;

  JobsBloc(this._jobsRepository) : super(const JobsInitial()) {
    on<LoadJobs>(_onLoadJobs);
    on<CreateJob>(_onCreateJob);
    on<ApplyForJob>(_onApplyForJob);
    on<UpdateJobStatus>(_onUpdateJobStatus);
  }

  Future<void> _onLoadJobs(LoadJobs event, Emitter<JobsState> emit) async {
    emit(const JobsLoading());
    try {
      final jobs = await _jobsRepository.getJobs(
        lat: event.lat,
        lng: event.lng,
        radius: event.radius,
        category: event.category,
        status: event.status,
      );
      emit(JobsLoaded(jobs));
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }

  Future<void> _onCreateJob(CreateJob event, Emitter<JobsState> emit) async {
    emit(const JobsLoading());
    try {
      final job = await _jobsRepository.createJob(
        title: event.title,
        description: event.description,
        categoryId: event.categoryId,
        budget: event.budget,
        isNegotiable: event.isNegotiable,
        location: event.location,
        date: event.date,
        time: event.time,
        urgency: event.urgency,
      );
      emit(JobCreated(job));
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }

  Future<void> _onApplyForJob(
      ApplyForJob event, Emitter<JobsState> emit) async {
    emit(const JobsLoading());
    try {
      await _jobsRepository.applyForJob(
        jobId: event.jobId,
        quotationAmount: event.quotationAmount,
        message: event.message,
      );
      emit(const JobApplicationSubmitted());
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }

  Future<void> _onUpdateJobStatus(
    UpdateJobStatus event,
    Emitter<JobsState> emit,
  ) async {
    emit(const JobsLoading());
    try {
      await _jobsRepository.updateJobStatus(
        jobId: event.jobId,
        status: event.status,
      );
      emit(const JobStatusUpdated());
    } catch (e) {
      emit(JobsError(e.toString()));
    }
  }
}
