import '../entities/worker.dart';

abstract class WorkerRepository {
  Future<void> createWorker(Worker worker);
  Future<Worker?> getWorkerById(String id);
  Future<List<Worker>> getWorkers();
}
