import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_button.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository.dart';
import 'package:tiroconnect/src/features/notifications/data/models/notification_model.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';
import 'dart:developer' as developer;

class WorkerRequestsPage extends StatefulWidget {
  const WorkerRequestsPage({super.key});

  @override
  State<WorkerRequestsPage> createState() => _WorkerRequestsPageState();
}

class _WorkerRequestsPageState extends State<WorkerRequestsPage> {
  late final ServiceRequestRepository _repository;
  late final NotificationRepository _notificationRepository;
  bool _isLoading = false;
  List<ServiceRequestModel> _requests = [];
  String? _workerId;

  @override
  void initState() {
    super.initState();
    _repository = getIt<ServiceRequestRepository>();
    _notificationRepository = getIt<NotificationRepository>();
    _loadWorkerId();
    _loadRequests();
  }

  void _loadWorkerId() {
    final user = AuthService().getCurrentUser();

    developer.log("========== AUTH CHECK ==========");
    developer.log("User: $user");
    developer.log("UID: ${user?.uid}");
    developer.log("Email: ${user?.email}");
    developer.log("================================");

    _workerId = user?.uid;
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    try {
      final requests = await _repository.getPendingRequests();
      setState(() {
        _requests =
            requests.map((e) => ServiceRequestModel.fromJson(e)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load requests: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Available Requests'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/worker-dashboard');
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? const Center(
                  child: Text(
                    'No available requests',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final request = _requests[index];
                    return _buildRequestCard(request);
                  },
                ),
    );
  }

  Widget _buildRequestCard(ServiceRequestModel request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getServiceIcon(request.service),
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    request.service,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getUrgencyColor(request.urgency)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.urgency.toUpperCase(),
                    style: TextStyle(
                      color: _getUrgencyColor(request.urgency),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
                Icons.category_outlined, 'Category', request.category),
            const SizedBox(height: 8),
            _buildInfoRow(
                Icons.location_on_outlined, 'Location', request.location),
            const SizedBox(height: 8),
            _buildInfoRow(
                Icons.description_outlined, 'Description', request.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final result =
                          await context.push('/request/${request.id}');
                      if (result == true) {
                        _loadRequests();
                      }
                    },
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Accept Job',
                    onPressed: () => _acceptJob(request),
                    icon: Icons.check_circle_outline,
                    backgroundColor: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Future<void> _acceptJob(ServiceRequestModel request) async {
    try {
      developer.log("ACCEPT STARTED");
      developer.log("Request ID: ${request.id}");
      developer.log("Worker ID: $_workerId");

      if (_workerId == null) {
        developer.log("ERROR: Worker ID is null, cannot accept job");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Error: Unable to accept job - worker not authenticated'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      await _repository.updateServiceRequest(
        request.id,
        {
          'status': 'accepted',
          'workerId': _workerId,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      developer.log("SERVICE REQUEST UPDATED");

      try {
        final repository = getIt<MessagingRepository>();
        final customerName = await repository.resolveDisplayName(
          userId: request.customerId,
          fallback: 'Customer',
        );
        final workerName = await repository.resolveDisplayName(
          userId: _workerId!,
          fallback: 'Worker',
        );
        final conversationId = await repository.getOrCreateConversation(
          userAId: request.customerId,
          userAName: customerName,
          userBId: _workerId!,
          userBName: workerName,
          contextId: request.id,
        );
        developer.log("CONVERSATION CREATED: $conversationId");

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
        developer.log("FAILED TO CREATE CONVERSATION: $e", error: e);
      }

      // Notify the customer that a worker accepted their request.
      try {
        await _notificationRepository.createNotification(
          NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: request.customerId,
            title: 'Job accepted',
            message: 'A worker has accepted your ${request.service} request.',
            requestId: request.id,
            createdAt: DateTime.now(),
          ),
        );
        developer.log("CUSTOMER NOTIFIED");
      } catch (e) {
        // Don't block the accept flow if notification creation fails.
        developer.log("FAILED TO NOTIFY CUSTOMER: $e", error: e);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job accepted successfully'),
          ),
        );
        _loadRequests();
      }
    } catch (e, stack) {
      developer.log("ACCEPT ERROR: $e", error: e, stackTrace: stack);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  IconData _getServiceIcon(String service) {
    final serviceLower = service.toLowerCase();
    if (serviceLower.contains('computer') || serviceLower.contains('repair')) {
      return Icons.computer;
    }
    if (serviceLower.contains('plumbing')) {
      return Icons.plumbing;
    }
    if (serviceLower.contains('tree') || serviceLower.contains('garden')) {
      return Icons.yard;
    }
    if (serviceLower.contains('electrical')) {
      return Icons.electrical_services;
    }
    if (serviceLower.contains('cleaning')) {
      return Icons.cleaning_services;
    }
    return Icons.work_outline;
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'emergency':
        return AppColors.error;
      case 'high':
        return AppColors.warning;
      case 'normal':
        return AppColors.info;
      default:
        return AppColors.success;
    }
  }
}
