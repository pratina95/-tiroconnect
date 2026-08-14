import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/core/widgets/custom_button.dart';

class PaymentPage extends StatefulWidget {
  final String jobId;
  final String? jobTitle;
  final String? workerName;
  final String? amount;

  const PaymentPage({
    super.key,
    required this.jobId,
    this.jobTitle,
    this.workerName,
    this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Payment'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildJobSummary(),
            const SizedBox(height: 24),
            _buildPaymentInfo(),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Confirm Payment',
              isLoading: _isLoading,
              onPressed: _confirmPayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Job Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(widget.jobTitle ?? 'Service request'),
            const SizedBox(height: 8),
            Text('Worker: ${widget.workerName ?? 'Not yet assigned'}'),
            const SizedBox(height: 8),
            Text(
              'Total: ${widget.amount ?? 'TBD'}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.phone_android, color: AppColors.primary),
              title: Text('Orange Money'),
              subtitle: Text('Mobile money payment'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Note: Payment integration will be added in production',
              style: TextStyle(
                  color: AppColors.textSecondary, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPayment() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment confirmed!')),
        );
        context.pop();
      }
    });
  }
}
