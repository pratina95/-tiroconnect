import 'package:injectable/injectable.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repository/worker_repository.dart';
import '../datasource/worker_firestore_datasource.dart';
import '../models/worker_model.dart';

@LazySingleton(as: WorkerRepository)
class WorkerRepositoryImpl implements WorkerRepository {
  final WorkerFirestoreDatasource datasource;

  WorkerRepositoryImpl(this.datasource);

  @override
  Future<void> createWorker(Worker worker) async {
    final model = WorkerModel(
      id: worker.id,
      name: worker.name,
      phone: worker.phone,
      location: worker.location,
      skills: worker.skills,
      experience: worker.experience,
      description: worker.description,
      profileImage: worker.profileImage,
      createdAt: worker.createdAt,
    );
    await datasource.createWorker(model);
  }

  @override
  Future<Worker?> getWorkerById(String id) async {
    final model = await datasource.getWorkerById(id);
    if (model == null) return null;
    return Worker(
      id: model.id,
      name: model.name,
      phone: model.phone,
      location: model.location,
      skills: model.skills,
      experience: model.experience,
      description: model.description,
      profileImage: model.profileImage,
      createdAt: model.createdAt,
      rating: model.rating,
      completedJobs: model.completedJobs,
    );
  }

  @override
  Future<List<Worker>> getWorkers() async {
    final models = await datasource.getWorkers();
    return models
        .map((model) => Worker(
              id: model.id,
              name: model.name,
              phone: model.phone,
              location: model.location,
              skills: model.skills,
              experience: model.experience,
              description: model.description,
              profileImage: model.profileImage,
              createdAt: model.createdAt,
              rating: model.rating,
              completedJobs: model.completedJobs,
            ))
        .toList();
  }
}
