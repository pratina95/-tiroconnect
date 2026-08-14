import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../models/worker_model.dart';

@lazySingleton
class WorkerFirestoreDatasource {
  final FirebaseFirestore firestore;

  WorkerFirestoreDatasource(this.firestore);

  Future<void> createWorker(WorkerModel worker) async {
    await firestore.collection("workers").doc(worker.id).set(worker.toMap());
  }

  Future<WorkerModel?> getWorkerById(String id) async {
    final doc = await firestore.collection("workers").doc(id).get();
    if (doc.exists) {
      return WorkerModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<List<WorkerModel>> getWorkers() async {
    final snapshot = await firestore.collection("workers").get();
    return snapshot.docs.map((doc) => WorkerModel.fromMap(doc.data())).toList();
  }
}
