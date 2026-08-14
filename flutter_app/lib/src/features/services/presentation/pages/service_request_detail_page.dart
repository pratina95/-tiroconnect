import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_button.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';
import 'dart:developer' as developer;

class ServiceRequestDetailPage extends StatefulWidget {
  final String requestId;

  const ServiceRequestDetailPage({super.key, required this.requestId});

  @override
  State<ServiceRequestDetailPage> createState() =>
      _ServiceRequestDetailPageState();
}

class _ServiceRequestDetailPageState extends State<ServiceRequestDetailPage> {
  final repository = getIt<ServiceRequestRepository>();
  ServiceRequestModel? _request;
  bool _isLoading = false;
  bool _isAccepting = false;
  String? _workerId;

  @override
  void initState() {
    super.initState();
    _loadWorkerId();
    _loadRequest();
  }

  void _loadWorkerId() {
    final user = AuthService().getCurrentUser();
    _workerId = user?.uid;
  }

  Future<void> _loadRequest() async {
    setState(() => _isLoading = true);
    try {
      final request = await repository.getServiceRequestById(widget.requestId);
      setState(() => _request = request);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load request: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _acceptJob() async {
    if (_workerId == null || _request == null) return;

    setState(() => _isAccepting = true);
    try {
      await repository.updateServiceRequest(widget.requestId, {
        'status': 'accepted',
        'workerId': _workerId,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      try {
        final repository = getIt<MessagingRepository>();
        final customerName = await repository.resolveDisplayName(
          userId: _request!.customerId,
          fallback: 'Customer',
        );
        final workerName = await repository.resolveDisplayName(
          userId: _workerId!,
          fallback: 'Worker',
        );
        final conversationId = await repository.getOrCreateConversation(
          userAId: _request!.customerId,
          userAName: customerName,
          userBId: _workerId!,
          userBName: workerName,
          contextId: widget.requestId,
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job accepted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept job: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isAccepting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Service Request Details'),
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_request == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Service Request Details'),
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
        body: const Center(child: Text('Request not found')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Service Request Details'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDetailSection(
                'Category', _request!.category, Icons.category_outlined),
            _buildDetailSection(
                'Service', _request!.service, Icons.work_outline),
            _buildDetailSection('Customer Location', _request!.location,
                Icons.location_on_outlined),
            _buildDetailSection('Description', _request!.description,
                Icons.description_outlined),
            _buildDetailSection('Urgency', _request!.urgency.toUpperCase(),
                Icons.priority_high),
            _buildDetailSection(
              'Date',
              '${_request!.createdAt.day}/${_request!.createdAt.month}/${_request!.createdAt.year}',
              Icons.calendar_today,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Accept Job',
              onPressed: _acceptJob,
              isLoading: _isAccepting,
              backgroundColor: AppColors.success,
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _request!.service,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Request ID: ${widget.requestId}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
