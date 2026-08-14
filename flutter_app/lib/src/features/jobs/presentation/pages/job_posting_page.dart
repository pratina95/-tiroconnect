import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_button.dart';
import 'package:tiroconnect/src/core/widgets/custom_text_field.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';
import 'package:uuid/uuid.dart';

class JobPostingPage extends StatefulWidget {
  const JobPostingPage({super.key});

  @override
  State<JobPostingPage> createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = '';
  bool _isNegotiable = true;
  String _selectedUrgency = 'normal';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Post a Job'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Job Title',
                hint: 'e.g., Fix leaking tap',
                prefixIcon: const Icon(Icons.work_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe what you need done',
                maxLines: 4,
                prefixIcon: const Icon(Icons.description_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildCategorySelector(),
              const SizedBox(height: 16),
              _buildBudgetField(),
              const SizedBox(height: 16),
              _buildNegotiableSwitch(),
              const SizedBox(height: 16),
              _buildLocationField(),
              const SizedBox(height: 16),
              _buildDateTimePicker(),
              const SizedBox(height: 16),
              _buildUrgencySelector(),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Post Job',
                onPressed: _postJob,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
      hint: const Text('Select Category'),
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : AppColors.surfaceDark,
      ),
      items: const [
        DropdownMenuItem(value: 'plumbing', child: Text('Plumbing')),
        DropdownMenuItem(value: 'electrical', child: Text('Electrical')),
        DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
        DropdownMenuItem(value: 'gardening', child: Text('Gardening')),
        DropdownMenuItem(value: 'carpentry', child: Text('Carpentry')),
        DropdownMenuItem(value: 'mechanics', child: Text('Mechanics')),
        DropdownMenuItem(value: 'hair_braiding', child: Text('Hair Braiding')),
        DropdownMenuItem(value: 'tutoring', child: Text('Tutoring')),
      ],
      onChanged: (value) {
        setState(() => _selectedCategory = value ?? '');
      },
    );
  }

  Widget _buildBudgetField() {
    return CustomTextField(
      controller: _budgetController,
      label: 'Budget (BWP)',
      hint: 'Enter your budget',
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.attach_money),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a budget';
        }
        return null;
      },
    );
  }

  Widget _buildNegotiableSwitch() {
    return SwitchListTile(
      title: const Text('Negotiable'),
      subtitle: const Text('Allow workers to negotiate the price'),
      value: _isNegotiable,
      onChanged: (value) => setState(() => _isNegotiable = value),
    );
  }

  Widget _buildLocationField() {
    return CustomTextField(
      controller: _locationController,
      label: 'Location',
      hint: 'Enter job location',
      prefixIcon: const Icon(Icons.location_on_outlined),
      readOnly: true,
      onTap: () {
        // Open location picker
      },
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: _selectDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : AppColors.surfaceDark,
              ),
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select date',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: _selectTime,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : AppColors.surfaceDark,
              ),
              child: Text(
                _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Select time',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencySelector() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedUrgency,
      decoration: InputDecoration(
        labelText: 'Urgency',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : AppColors.surfaceDark,
      ),
      items: const [
        DropdownMenuItem(value: 'low', child: Text('Low')),
        DropdownMenuItem(value: 'normal', child: Text('Normal')),
        DropdownMenuItem(value: 'high', child: Text('High')),
        DropdownMenuItem(value: 'emergency', child: Text('Emergency')),
      ],
      onChanged: (value) {
        setState(() => _selectedUrgency = value ?? 'normal');
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _postJob() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = AuthService().getCurrentUser();
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be logged in to post a job.'),
            ),
          );
        }
        return;
      }

      final repository = getIt<ServiceRequestRepository>();
      final customerId = user.uid;

      final request = ServiceRequestModel(
        id: const Uuid().v4(),
        customerId: customerId,
        category: _selectedCategory,
        service: _titleController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        urgency: _selectedUrgency,
        status: ServiceRequestStatus.pending,
        createdAt: DateTime.now(),
      );

      try {
        await repository.createServiceRequest(request);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job posted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to post job: $e')),
          );
        }
      }

      if (mounted) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/role');
        }
      }
    }
  }
}
