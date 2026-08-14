import 'package:flutter/material.dart';
import 'package:tiroconnect/src/features/home/presentation/pages/home_page.dart';
import 'package:tiroconnect/src/features/jobs/presentation/pages/job_posting_page.dart';
import 'package:tiroconnect/src/features/messaging/presentation/pages/conversations_list_page.dart';
import 'package:tiroconnect/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:tiroconnect/src/features/customer/presentation/pages/customer_profile_page.dart';

class CustomerNavigation extends StatefulWidget {
  const CustomerNavigation({super.key});

  @override
  State<CustomerNavigation> createState() => _CustomerNavigationState();
}

class _CustomerNavigationState extends State<CustomerNavigation> {
  int index = 0;

  final pages = [
    const HomePage(),
    const ConversationsListPage(),
    const JobPostingPage(),
    const NotificationsPage(),
    const CustomerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
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
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Post",
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
