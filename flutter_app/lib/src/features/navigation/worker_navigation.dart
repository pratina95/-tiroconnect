import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiroconnect/src/features/workers/presentation/pages/worker_jobs_page.dart';
import 'package:tiroconnect/src/features/workers/presentation/pages/worker_dashboard_page.dart';
import 'package:tiroconnect/src/features/messaging/presentation/pages/conversations_list_page.dart';
import 'package:tiroconnect/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:tiroconnect/src/features/profile/presentation/pages/worker_profile_page.dart';
import 'dart:developer' as developer;

class WorkerNavigation extends StatefulWidget {
  const WorkerNavigation({super.key});
  @override
  State<WorkerNavigation> createState() => _WorkerNavigationState();
}

class _WorkerNavigationState extends State<WorkerNavigation> {
  int index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _pages = [
      const WorkerDashboardPage(),
      const WorkerJobsPage(),
      const ConversationsListPage(),
      const NotificationsPage(),
      WorkerProfilePage(workerId: currentUid),
    ];
  }

  @override
  Widget build(BuildContext context) {
    developer.log("WORKER NAVIGATION OPENED - index: $index");

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
