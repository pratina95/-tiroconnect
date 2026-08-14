import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_button.dart';
import 'package:tiroconnect/src/core/widgets/custom_text_field.dart';
import 'package:tiroconnect/src/features/services/data/models/service_request_model.dart';
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart';

class OutdoorServicesPage extends StatefulWidget {
  const OutdoorServicesPage({super.key});

  @override
  State<OutdoorServicesPage> createState() => _OutdoorServicesPageState();
}

class _OutdoorServicesPageState extends State<OutdoorServicesPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedService = '';
  final String _selectedUrgency = 'normal';
  bool _isLoading = false;

  late final ServiceRequestRepository _repository;

  final List<String> _services = [
    'Garden Maintenance',
    'Lawn Mowing',
    'Tree Trimming',
    'Landscaping',
    'Fence Installation',
    'Paving',
  ];

  @override
  void initState() {
    super.initState();
    _repository = getIt<ServiceRequestRepository>();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Outdoor & Garden'),
        centerTitle: true,
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.yard,
                      color: AppColors.success,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Outdoor & Garden Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Services:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ..._services.map((service) => _buildServiceItem(service)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue:
                    _selectedService.isEmpty ? null : _selectedService,
                hint: const Text('Select a service'),
                decoration: InputDecoration(
                  labelText: 'Service Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : AppColors.surfaceDark,
                ),
                items: _services
                    .map((service) => DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedService = value ?? '');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Enter your location',
                prefixIcon: const Icon(Icons.location_on_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
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
                prefixIcon: const Icon(Icons.notes),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Request Service',
                onPressed: _requestService,
                icon: Icons.send,
                backgroundColor: AppColors.success,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(String service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            service,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _requestService() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final currentUser = AuthService().getCurrentUser();
        final customerId = currentUser?.uid ?? 'guest_user';

        final serviceRequest = ServiceRequestModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerId: customerId,
          category: 'Outdoor & Garden',
          service: _selectedService,
          location: _locationController.text,
          description: _descriptionController.text,
          urgency: _selectedUrgency,
          createdAt: DateTime.now(),
        );

        await _repository.createServiceRequest(serviceRequest);

        setState(() => _isLoading = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service request submitted successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit request: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
