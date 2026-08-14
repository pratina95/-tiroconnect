import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/features/workers/domain/entities/worker.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart';

class WorkerProfilePage extends StatefulWidget {
  final String workerId;

  const WorkerProfilePage({super.key, required this.workerId});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  late Future<Worker?> _workerFuture;

  @override
  void initState() {
    super.initState();
    _workerFuture = _fetchWorker();
  }

  Future<Worker?> _fetchWorker() {
    final repository = getIt<WorkerRepository>();
    return repository.getWorkerById(widget.workerId);
  }

  bool get _isOwnProfile =>
      FirebaseAuth.instance.currentUser?.uid == widget.workerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_isOwnProfile ? 'My Profile' : 'Worker Profile'),
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
      body: FutureBuilder<Worker?>(
        future: _workerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 40, color: AppColors.error),
                    const SizedBox(height: 12),
                    const Text('Could not load this profile.'),
                    const SizedBox(height: 4),
                    Text(
                      '${snapshot.error}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _workerFuture = _fetchWorker();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final worker = snapshot.data;
          if (worker == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_off_outlined,
                        size: 40, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    const Text('No worker profile found for this account.'),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Worker Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary,
                        backgroundImage: (worker.profileImage != null &&
                                worker.profileImage!.isNotEmpty)
                            ? NetworkImage(worker.profileImage!)
                            : null,
                        child: (worker.profileImage == null ||
                                worker.profileImage!.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        worker.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        worker.experience,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Section
                const Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(worker.phone),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(worker.location),
                ),
                const SizedBox(height: 24),

                // Services Section
                if (worker.skills.isNotEmpty) ...[
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: worker.skills
                        .map((skill) => _buildServiceChip(skill))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Description Section
                if (worker.description.isNotEmpty) ...[
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    worker.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                ],

                if (!_isOwnProfile) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('Message'),
                      onPressed: () => _startConversation(context, worker),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_isOwnProfile)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      onPressed: () => _confirmLogout(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/role');
      }
    }
  }

  Future<void> _startConversation(BuildContext context, Worker worker) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please sign in to message this worker.')),
        );
      }
      return;
    }

    try {
      final myName = await _resolveMyDisplayName(currentUser);
      final repository = getIt<MessagingRepository>();
      final conversationId = await repository.getOrCreateConversation(
        userAId: currentUser.uid,
        userAName: myName,
        userBId: worker.id,
        userBName: worker.name,
        contextId: 'profile:${worker.id}',
      );

      if (context.mounted) {
        context.push('/chat/$conversationId');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start chat: $e')),
        );
      }
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

    try {
      final customerDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(currentUser.uid)
          .get();
      final customerName = customerDoc.data()?['name'] as String?;
      if (customerName != null && customerName.trim().isNotEmpty) {
        return customerName.trim();
      }
    } catch (_) {}

    return currentUser.email ?? 'User';
  }

  Widget _buildServiceChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
    );
  }
}
