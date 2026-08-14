import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  final repository = getIt<ServiceRequestRepository>();
  List<ServiceRequestModel> _requests = [];
  bool _isLoading = false;
  String? _customerId;
  final Set<String> _shownChatPrompts = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _requestSubscription;

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
    _loadRequests();
    _subscribeToRequestUpdates();
  }

  @override
  void dispose() {
    _requestSubscription?.cancel();
    super.dispose();
  }

  void _loadCustomerId() {
    final user = AuthService().getCurrentUser();
    _customerId = user?.uid;
  }

  void _subscribeToRequestUpdates() {
    if (_customerId == null) return;
    _requestSubscription = FirebaseFirestore.instance
        .collection('service_requests')
        .where('customerId', isEqualTo: _customerId)
        .snapshots()
        .listen((snapshot) {
      final updatedRequests = snapshot.docs.map((doc) {
        final data = doc.data();
        return ServiceRequestModel.fromJson(data..['id'] = doc.id);
      }).toList();
      if (mounted) {
        setState(() {
          _requests = updatedRequests;
          _maybeShowChatPrompt();
        });
      }
    }, onError: (_) {});
  }

  Future<void> _loadRequests() async {
    if (_customerId == null) return;

    setState(() => _isLoading = true);
    try {
      final requests = await repository.getServiceRequests(
        customerId: _customerId,
      );
      setState(() => _requests = requests);
      _maybeShowChatPrompt();
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
        title: const Text('My Requests'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/role');
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? const Center(
                  child: Text(
                    'No requests found',
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
                _buildStatusBadge(request.status.toString().split('.').last),
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
            if (request.workerId != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person_outline, 'Worker', request.workerId!),
            ],
            const SizedBox(height: 16),
            if (request.status.toString().split('.').last == 'accepted' &&
                request.workerId != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _messageWorker(request),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Message Worker'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _maybeShowChatPrompt() {
    ServiceRequestModel? acceptedRequest;
    for (final request in _requests) {
      final status = request.status.toString().split('.').last;
      if (status == 'accepted' && request.workerId != null) {
        acceptedRequest = request;
        break;
      }
    }

    if (acceptedRequest == null) return;
    if (_shownChatPrompts.contains(acceptedRequest.id)) return;

    _shownChatPrompts.add(acceptedRequest.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('New chat ready'),
          content: const Text('Open the conversation with your worker now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (acceptedRequest != null) {
                  _messageWorker(acceptedRequest);
                }
              },
              child: const Text('Open chat'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _messageWorker(ServiceRequestModel request) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || request.workerId == null) return;

    final worker =
        await getIt<WorkerRepository>().getWorkerById(request.workerId!);
    if (worker == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load worker details.')),
        );
      }
      return;
    }

    final repository = getIt<MessagingRepository>();
    final myName = await _resolveMyDisplayName(currentUser);
    final conversationId = await repository.getOrCreateConversation(
      userAId: currentUser.uid,
      userAName: myName,
      userBId: worker.id,
      userBName: worker.name,
      contextId: request.id,
    );

    if (mounted) {
      context.push('/chat/$conversationId');
    }
  }

  Future<String> _resolveMyDisplayName(User currentUser) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final fullName = doc.data()?['fullName'] as String?;
      if (fullName != null && fullName.trim().isNotEmpty) {
        return fullName.trim();
      }
    } catch (_) {}
    return currentUser.email ?? 'User';
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        break;
      case 'accepted':
        color = AppColors.success;
        break;
      case 'inprogress':
        color = AppColors.info;
        break;
      case 'completed':
        color = AppColors.success;
        break;
      case 'cancelled':
        color = AppColors.error;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
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
}
