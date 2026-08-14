import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_button.dart';
import 'package:tiroconnect/src/core/widgets/custom_text_field.dart';
import 'package:tiroconnect/src/features/workers/data/models/worker_model.dart';
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart';
import 'package:tiroconnect/src/features/workers/domain/entities/worker.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'dart:developer' as developer;

class WorkerRegisterPage extends StatefulWidget {
  const WorkerRegisterPage({super.key});

  @override
  State<WorkerRegisterPage> createState() => _WorkerRegisterPageState();
}

class _WorkerRegisterPageState extends State<WorkerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final descriptionController = TextEditingController();

  bool loading = false;
  String? _workerId;

  @override
  void initState() {
    super.initState();
    _loadWorkerId();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    skillsController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _loadWorkerId() {
    final user = AuthService().getCurrentUser();
    _workerId = user?.uid;
    developer.log("REGISTER PAGE - USER ID: $_workerId");
  }

  Future<void> registerWorker() async {
    if (_workerId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated. Please login first.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      loading = true;
    });

    // Parse skills from comma-separated string to list
    final skillsList = skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final worker = WorkerModel(
      id: _workerId!, // Use Firebase Auth UID instead of random UUID
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      location: locationController.text.trim(),
      skills: skillsList,
      experience: experienceController.text.trim(),
      description: descriptionController.text.trim(),
      createdAt: DateTime.now(),
    );

    final repository = getIt<WorkerRepository>();

    try {
      await FirebaseFirestore.instance.collection('users').doc(_workerId!).set(
            AuthService.buildUserProfileData(
              fullName: worker.name,
              email: AuthService().getCurrentUser()?.email ?? '',
              phoneNumber: worker.phone,
              role: 'worker',
            ),
          );

      await repository.createWorker(Worker(
        id: worker.id,
        name: worker.name,
        phone: worker.phone,
        location: worker.location,
        skills: worker.skills,
        experience: worker.experience,
        description: worker.description,
        profileImage: worker.profileImage,
        createdAt: worker.createdAt,
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Worker registration successful!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/worker-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Worker Registration"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Complete Your Worker Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill in your details to start accepting jobs',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: locationController,
                  label: 'Location',
                  hint: 'Enter your location',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: skillsController,
                  label: 'Skills (comma separated)',
                  hint: 'e.g., Plumbing, Electrical',
                  prefixIcon: const Icon(Icons.work_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one skill';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: experienceController,
                  label: 'Experience',
                  hint: 'Years of experience',
                  prefixIcon: const Icon(Icons.timeline_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your experience';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Tell us about yourself',
                  prefixIcon: const Icon(Icons.description_outlined),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Register Worker',
                  isLoading: loading,
                  onPressed: registerWorker,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
