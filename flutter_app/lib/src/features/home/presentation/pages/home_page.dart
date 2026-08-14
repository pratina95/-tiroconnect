import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/features/home/presentation/widgets/category_grid.dart';
import 'package:tiroconnect/src/features/home/presentation/widgets/search_bar.dart';
import 'package:tiroconnect/src/features/home/presentation/widgets/emergency_banner.dart';
import 'package:tiroconnect/src/features/notifications/data/models/notification_model.dart';
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository.dart';
import 'package:tiroconnect/src/features/workers/domain/entities/worker.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';
import 'package:tiroconnect/src/features/home/presentation/widgets/worker_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _unreadCount = 0;
  late Future<List<Worker>> _featuredWorkersFuture;
  StreamSubscription<List<NotificationModel>>? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _featuredWorkersFuture = getIt<WorkerRepository>().getWorkers();
    _subscribeToUnreadNotifications();
  }

  void _subscribeToUnreadNotifications() {
    final user = AuthService().getCurrentUser();
    if (user == null) return;
    final repository = getIt<NotificationRepository>();
    _notificationSubscription =
        repository.watchNotifications(user.uid).listen((notifications) {
      if (!mounted) return;
      final count = notifications.where((n) => !n.read).length;
      setState(() => _unreadCount = count);
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'TiroConnect',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => context.push('/notifications'),
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$_unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const CustomSearchBar(),
          const SizedBox(height: 16),
          const EmergencyBanner(),
          const SizedBox(height: 24),
          Text(
            'Service Categories',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const CategoryGrid(),
          const SizedBox(height: 24),
          Text(
            'Featured Workers',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: FutureBuilder<List<Worker>>(
              future: _featuredWorkersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load workers.'));
                }
                final workers = snapshot.data ?? [];
                if (workers.isEmpty) {
                  return const Center(child: Text('No workers available.'));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    return WorkerCard(worker: worker);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
