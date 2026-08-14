import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';

class WorkerJobsPage extends StatefulWidget {
  const WorkerJobsPage({super.key});

  @override
  State<WorkerJobsPage> createState() => _WorkerJobsPageState();
}

class _WorkerJobsPageState extends State<WorkerJobsPage> {
  final repository = GetIt.instance<ServiceRequestRepository>();

  List<ServiceRequestModel> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final user = AuthService().getCurrentUser();

      print("WORKER JOB QUERY UID: ${user?.uid}");

      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final result = await repository.getWorkerJobs(user.uid);

      print("JOBS FOUND: ${result.length}");

      setState(() {
        jobs = result;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR LOADING JOBS: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobs.isEmpty) {
      return const Center(child: Text('No jobs found'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs')),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.service,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Location: ${job.location}"),
                  Text("Description: ${job.description}"),
                  Text("Status: ${job.status.name}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
