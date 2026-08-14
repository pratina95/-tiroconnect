import 'package:flutter/material.dart';
import 'package:tiroconnect/src/features/navigation/customer_navigation.dart';
import 'package:tiroconnect/src/features/navigation/worker_navigation.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, default to customer if no user or role not set
    // In production, you would fetch the user role from Firestore
    final userRole = 'customer'; // Default role

    if (userRole == 'worker') {
      return const WorkerNavigation();
    }

    return const CustomerNavigation();
  }
}
