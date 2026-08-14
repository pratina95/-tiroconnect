import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/core/theme/app_colors.dart';
import 'package:tiroconnect/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tiroconnect/src/features/auth/data/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Make sure we have the latest auth state when this page opens
    // (covers the case where the page is opened directly, e.g. via deep link,
    // before anything else has dispatched CheckAuthStatus).
    final state = context.read<AuthBloc>().state;
    if (state is! Authenticated) {
      context.read<AuthBloc>().add(const CheckAuthStatus());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(context, user),
                  const SizedBox(height: 24),
                  // NOTE: Jobs/Rating/Earnings are worker-specific stats that
                  // live in WorkerProfileModel (Firestore), not in AuthBloc's
                  // state. Wire these up with a real fetch by user.id before
                  // shipping — right now they're still placeholder values.
                  _buildStatsSection(context),
                  const SizedBox(height: 24),
                  _buildMenuSection(context),
                ],
              ),
            );
          }

          // Unauthenticated / AuthError / anything else
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('You are not logged in.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/worker-login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                backgroundImage: (user.profilePicture != null &&
                        user.profilePicture!.isNotEmpty)
                    ? NetworkImage(user.profilePicture!)
                    : null,
                child: (user.profilePicture == null ||
                        user.profilePicture!.isEmpty)
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.phoneNumber,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _roleLabel(user.role),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.worker:
        return 'Worker';
      case UserRole.business:
        return 'Business';
      case UserRole.admin:
        return 'Admin';
    }
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Jobs', '—'),
        _buildStatItem('Rating', '—'),
        _buildStatItem('Earnings', '—'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          'My Jobs',
          Icons.work_outline,
          () => context.go('/jobs'),
        ),
        _buildMenuItem(
          context,
          'Messages',
          Icons.chat_outlined,
          () => context.go('/messages'),
        ),
        _buildMenuItem(
          context,
          'Payments',
          Icons.payment_outlined,
          () => context.go('/payments'),
        ),
        _buildMenuItem(
          context,
          'Reviews',
          Icons.star_outline,
          () {},
        ),
        _buildMenuItem(
          context,
          'Settings',
          Icons.settings_outlined,
          () {},
        ),
        _buildMenuItem(
          context,
          'Help & Support',
          Icons.help_outline,
          () {},
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              context.read<AuthBloc>().add(const Logout());
              context.go('/role');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
