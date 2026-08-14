import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository.dart';
import 'package:tiroconnect/src/features/notifications/data/models/notification_model.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';
import 'dart:developer' as developer;

class WorkerJobsPage extends StatefulWidget {
  const WorkerJobsPage({super.key});
  @override
  State<WorkerJobsPage> createState() => _WorkerJobsPageState();
}

class _WorkerJobsPageState extends State<WorkerJobsPage> {
  final repository = GetIt.instance<ServiceRequestRepository>();
  final notificationRepository = GetIt.instance<NotificationRepository>();
  List<ServiceRequestModel> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => isLoading = true);
    try {
      final user = AuthService().getCurrentUser();
      developer.log("WORKER JOB QUERY UID: ${user?.uid}");
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }
      final result = await repository.getWorkerJobs(user.uid);
      developer.log("JOBS FOUND: ${result.length}");
      setState(() {
        jobs = result;
        isLoading = false;
      });
    } catch (e) {
      developer.log("ERROR LOADING JOBS: $e", error: e);
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateStatus(
    ServiceRequestModel job,
    ServiceRequestStatus newStatus,
  ) async {
    try {
      await repository.updateServiceRequest(
        job.id,
        {
          'status': newStatus.name,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      if (newStatus == ServiceRequestStatus.accepted) {
        try {
          final conversationId = await GetIt.instance<MessagingRepository>()
              .getOrCreateConversation(
            userAId: job.customerId,
            userAName: 'Customer',
            userBId: AuthService().getCurrentUser()?.uid ?? '',
            userBName: 'Worker',
            contextId: job.id,
          );
          developer.log('CONVERSATION CREATED: $conversationId');
        } catch (e) {
          developer.log('FAILED TO CREATE CONVERSATION: $e', error: e);
        }
      }

      // Notify the customer about the status change.
      final statusLabel = newStatus == ServiceRequestStatus.inProgress
          ? 'started'
          : 'completed';
      await notificationRepository.createNotification(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: job.customerId,
          title: 'Job $statusLabel',
          message: 'Your ${job.service} request has been $statusLabel.',
          requestId: job.id,
          createdAt: DateTime.now(),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job marked as $statusLabel')),
        );
      }
      _loadJobs();
    } catch (e) {
      developer.log("ERROR UPDATING JOB STATUS: $e", error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update job: $e')),
        );
      }
    }
  }

  Widget? _buildActionButton(ServiceRequestModel job) {
    switch (job.status) {
      case ServiceRequestStatus.accepted:
        return ElevatedButton(
          onPressed: () => _updateStatus(job, ServiceRequestStatus.inProgress),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
          ),
          child: const Text('Start Job'),
        );
      case ServiceRequestStatus.inProgress:
        return ElevatedButton(
          onPressed: () => _updateStatus(job, ServiceRequestStatus.completed),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
          ),
          child: const Text('Mark Completed'),
        );
      default:
        return null;
    }
  }

  Future<void> _messageCustomer(ServiceRequestModel job) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final myWorker =
        await GetIt.instance<WorkerRepository>().getWorkerById(currentUser.uid);
    final myName = myWorker?.name ?? currentUser.email ?? 'Worker';

    String customerName = 'Customer';
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(job.customerId)
          .get();
      final fullName = doc.data()?['fullName'] as String?;
      if (fullName != null && fullName.trim().isNotEmpty) {
        customerName = fullName.trim();
      }
    } catch (_) {}

    final conversationId =
        await GetIt.instance<MessagingRepository>().getOrCreateConversation(
      userAId: currentUser.uid,
      userAName: myName,
      userBId: job.customerId,
      userBName: customerName,
      contextId: job.id,
    );

    if (mounted) {
      context.push('/chat/$conversationId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () async {
                // Browse and accept jobs that aren't claimed yet.
                await context.push('/worker-requests');
                // Refresh in case a job was just accepted there.
                _loadJobs();
              },
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Available'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadJobs,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : jobs.isEmpty
                ? ListView(
                    // ListView (not Center) so pull-to-refresh works even
                    // when the list is empty.
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No jobs found')),
                      SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Tap "Available" above to browse jobs you can accept.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final actionButton = _buildActionButton(job);
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
                              if (job.status !=
                                  ServiceRequestStatus.pending) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _messageCustomer(job),
                                    icon: const Icon(Icons.chat_outlined),
                                    label: const Text('Message Customer'),
                                  ),
                                ),
                              ],
                              if (actionButton != null) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: actionButton,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
