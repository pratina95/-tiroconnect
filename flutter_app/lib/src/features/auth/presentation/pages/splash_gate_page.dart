import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';

/// Shown briefly on app launch. Checks whether the person is already
/// logged in (Firebase Auth persists sessions automatically) and, if so,
/// routes straight to their dashboard instead of making them log in again.
class SplashGatePage extends StatefulWidget {
  const SplashGatePage({super.key});

  @override
  State<SplashGatePage> createState() => _SplashGatePageState();
}

class _SplashGatePageState extends State<SplashGatePage> {
  @override
  void initState() {
    super.initState();
    _decideDestination();
  }

  Future<void> _decideDestination() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Not logged in at all - let them pick a role / log in normally.
      if (mounted) context.go('/role');
      return;
    }

    // Logged in. Currently we only have a reliable way to detect worker
    // accounts (via the workers collection). Customer-account detection
    // can be added here the same way once that data exists.
    try {
      final workerRepo = GetIt.instance<WorkerRepository>();
      final worker = await workerRepo.getWorkerById(user.uid);

      if (worker != null) {
        if (mounted) context.go('/worker-dashboard');
        return;
      }
    } catch (_) {
      // Fall through to role selection if the check fails for any reason.
    }

    if (mounted) context.go('/role');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
