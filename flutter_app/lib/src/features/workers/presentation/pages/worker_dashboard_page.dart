import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:tiroconnect/src/features/workers/domain/entities/worker.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository.dart';
import 'package:tiroconnect/src/features/notifications/data/models/notification_model.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';
import 'dart:developer' as developer;

class WorkerDashboardPage extends StatefulWidget {
  const WorkerDashboardPage({super.key});

  @override
  State<WorkerDashboardPage> createState() => _WorkerDashboardPageState();
}

class _WorkerDashboardPageState extends State<WorkerDashboardPage> {
  String? _workerId;
  Worker? _worker;
  List<ServiceRequestModel> _myJobs = [];
  List<ServiceRequestModel> _availableJobs = [];
  bool _isLoading = false;
  final ServiceRequestRepository _requestRepo =
      GetIt.instance<ServiceRequestRepository>();
  final NotificationRepository _notificationRepo =
      GetIt.instance<NotificationRepository>();

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    final user = AuthService().getCurrentUser();

    developer.log("========== WORKER DEBUG ==========");
    developer.log("UID: ${user?.uid}");
    developer.log("EMAIL: ${user?.email}");
    developer.log("==================================");

    if (user == null) {
      developer.log("No authenticated user.");
      return;
    }

    _workerId = user.uid;

    await _loadWorkerData();
  }

  Future<void> _loadWorkerData() async {
    if (_workerId == null) {
      developer.log("No worker ID found - user not logged in");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Load worker profile
      final workerRepo = GetIt.instance<WorkerRepository>();
      final worker = await workerRepo.getWorkerById(_workerId!);

      developer.log("WORKER FROM FIRESTORE:");
      developer.log(worker.toString());
      developer.log("==================================");

      // Load worker's jobs (accepted requests)
      final requestRepo = GetIt.instance<ServiceRequestRepository>();
      developer.log("STEP 1 - Repository obtained");
      final jobs = await requestRepo.getWorkerJobs(_workerId!);
      developer.log("STEP 2 - My jobs: ${jobs.length}");
      final availableJobs = await requestRepo.getAvailableJobs();
      developer.log("STEP 3 - Available jobs: ${availableJobs.length}");

      setState(() {
        _worker = worker;
        _myJobs = jobs;
        _availableJobs = availableJobs;
      });

      developer.log("Worker loaded: ${_worker?.name}");
      developer.log("Jobs count: ${_myJobs.length}");
    } catch (e) {
      developer.log("Error loading worker data: $e", error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptJobFromDashboard(ServiceRequestModel job) async {
    if (_workerId == null) return;

    await _requestRepo.updateServiceRequest(
      job.id,
      {
        'workerId': _workerId,
        'status': 'accepted',
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );

    try {
      final repository = GetIt.instance<MessagingRepository>();
      final customerName = await repository.resolveDisplayName(
        userId: job.customerId,
        fallback: 'Customer',
      );
      final workerName = await repository.resolveDisplayName(
        userId: _workerId!,
        fallback: _worker?.name ?? 'Worker',
      );
      final conversationId = await repository.getOrCreateConversation(
        userAId: job.customerId,
        userAName: customerName,
        userBId: _workerId!,
        userBName: workerName,
        contextId: job.id,
      );
      developer.log('CONVERSATION CREATED: $conversationId');

      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Chat ready'),
            content: const Text('Open the conversation now?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Later'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.push('/chat/$conversationId');
                },
                child: const Text('Open chat'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      developer.log('FAILED TO CREATE CONVERSATION: $e', error: e);
    }

    // Notify the customer that a worker accepted their request.
    try {
      await _notificationRepo.createNotification(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: job.customerId,
          title: 'Job accepted',
          message: 'A worker has accepted your ${job.service} request.',
          requestId: job.id,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      developer.log("FAILED TO NOTIFY CUSTOMER: $e", error: e);
    }

    _loadWorkerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Worker Profile Header
                  if (_worker != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${_worker!.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Skills: ${_worker!.skills.join(", ")}'),
                            Text('Location: ${_worker!.location}'),
                          ],
                        ),
                      ),
                    ),
                  if (_worker == null && _workerId != null)
                    Card(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Couldn\'t load your profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                                'There was a problem loading your worker data.'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadWorkerData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Earnings Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Earnings Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Total Earnings: P0.00'),
                          Text('This Month: P0.00'),
                          Text('Pending: P0.00'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Available Jobs
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Jobs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_availableJobs.isEmpty)
                            const Text('No available jobs')
                          else
                            ..._availableJobs
                                .take(3)
                                .map((job) => _buildAvailableJobItem(job)),
                          if (_availableJobs.length > 3)
                            TextButton(
                              onPressed: () async {
                                await context.push('/worker-requests');
                                _loadWorkerData();
                              },
                              child: const Text('View All Available Jobs'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // My Jobs
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Jobs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_myJobs.isEmpty)
                            const Text('No jobs yet')
                          else
                            ..._myJobs.take(3).map((job) => _buildJobItem(job)),
                          if (_myJobs.length > 3)
                            TextButton(
                              onPressed: () {
                                context.go('/worker-jobs');
                              },
                              child: const Text('View My Jobs'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Completed Jobs
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Completed Jobs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                              '${_myJobs.where((j) => j.status == ServiceRequestStatus.completed).length} completed'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('No ratings yet'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Availability
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Status: Available'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Actions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.go('/worker-jobs');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('View My Jobs'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAvailableJobItem(ServiceRequestModel job) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.work_outline,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.service,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  job.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _acceptJobFromDashboard(job),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  Widget _buildJobItem(ServiceRequestModel job) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.work_outline,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              job.service,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            job.status.name,
            style: TextStyle(
              color: _getStatusColor(job.status),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.pending:
        return AppColors.info;
      case ServiceRequestStatus.accepted:
        return AppColors.warning;
      case ServiceRequestStatus.inProgress:
        return AppColors.primary;
      case ServiceRequestStatus.completed:
        return AppColors.success;
      case ServiceRequestStatus.cancelled:
        return AppColors.error;
    }
  }
}
