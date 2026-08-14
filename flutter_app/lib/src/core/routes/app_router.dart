import 'package:go_router/go_router.dart';
import 'package:tiroconnect/src/features/home/presentation/pages/home_page.dart';
import 'package:tiroconnect/src/features/jobs/presentation/pages/job_posting_page.dart';
import 'package:tiroconnect/src/features/jobs/presentation/pages/job_details_page.dart';
import 'package:tiroconnect/src/features/messaging/presentation/pages/chat_page.dart';
import 'package:tiroconnect/src/features/messaging/presentation/pages/conversations_list_page.dart';
import 'package:tiroconnect/src/features/profile/presentation/pages/profile_page.dart';
import 'package:tiroconnect/src/features/profile/presentation/pages/worker_profile_page.dart';
import 'package:tiroconnect/src/features/payments/presentation/pages/payment_page.dart';
import 'package:tiroconnect/src/features/notifications/presentation/pages/notifications_page.dart';
import 'package:tiroconnect/src/features/search/presentation/pages/search_page.dart';
import 'package:tiroconnect/src/features/business/presentation/pages/business_dashboard_page.dart';
import 'package:tiroconnect/src/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/technology_services_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/emergency_services_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/outdoor_services_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/cooking_services_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/home_services_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/vehicle_services_page.dart';
import 'package:tiroconnect/src/features/workers/presentation/pages/worker_jobs_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/worker_requests_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/service_request_detail_page.dart';
import 'package:tiroconnect/src/features/services/presentation/pages/my_requests_page.dart';
import 'package:tiroconnect/src/features/auth/presentation/pages/role_selection_page.dart';
import 'package:tiroconnect/src/features/navigation/customer_navigation.dart';
import 'package:tiroconnect/src/features/workers/presentation/pages/worker_registration_page.dart';
import 'package:tiroconnect/src/features/workers/presentation/pages/worker_login_page.dart';
import 'package:tiroconnect/src/features/navigation/worker_navigation.dart';
import 'package:tiroconnect/src/features/customer/presentation/pages/customer_login_page.dart';
import 'package:tiroconnect/src/features/customer/presentation/pages/customer_registration_page.dart';
import 'package:tiroconnect/src/features/navigation/presentation/pages/main_navigation_page.dart';
import 'package:tiroconnect/src/features/auth/presentation/pages/otp_verification_page.dart';

final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/role',
    routes: <RouteBase>[
      // Main App Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Job Routes
      GoRoute(
        path: '/post-job',
        name: 'post-job',
        builder: (context, state) => const JobPostingPage(),
      ),
      GoRoute(
        path: '/job/:id',
        name: 'job-details',
        builder: (context, state) {
          final jobId = state.pathParameters['id'] ?? '';
          return JobDetailsPage(jobId: jobId);
        },
      ),

      // Search & Discovery
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),

      // Profile Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/worker/:id',
        name: 'worker-profile',
        builder: (context, state) {
          final workerId = state.pathParameters['id'] ?? '';
          return WorkerProfilePage(workerId: workerId);
        },
      ),

      // Messaging
      GoRoute(
        path: '/chat/:id',
        name: 'chat',
        builder: (context, state) {
          final conversationId = state.pathParameters['id'] ?? '';
          return ChatPage(conversationId: conversationId);
        },
      ),

      // Payments
      GoRoute(
        path: '/payment/:id',
        name: 'payment',
        builder: (context, state) {
          final jobId = state.pathParameters['id'] ?? '';
          return PaymentPage(jobId: jobId);
        },
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      // Business Dashboard
      GoRoute(
        path: '/business-dashboard',
        name: 'business-dashboard',
        builder: (context, state) => const BusinessDashboardPage(),
      ),

      // Admin Dashboard
      GoRoute(
        path: '/admin-dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),

      // Service Pages
      GoRoute(
        path: '/services/emergency',
        name: 'emergency-services',
        builder: (context, state) => const EmergencyServicesPage(),
      ),
      GoRoute(
        path: '/services/outdoor',
        name: 'outdoor-services',
        builder: (context, state) => const OutdoorServicesPage(),
      ),
      GoRoute(
        path: '/services/technology',
        name: 'technology-services',
        builder: (context, state) => const TechnologyServicesPage(),
      ),
      GoRoute(
        path: '/services/cooking',
        name: 'cooking-services',
        builder: (context, state) => const CookingServicesPage(),
      ),
      GoRoute(
        path: '/services/home',
        name: 'home-services',
        builder: (context, state) => const HomeServicesPage(),
      ),
      GoRoute(
        path: '/services/vehicle',
        name: 'vehicle-services',
        builder: (context, state) => const VehicleServicesPage(),
      ),

      // Worker Jobs
      GoRoute(
        path: '/worker-jobs',
        builder: (context, state) => const WorkerJobsPage(),
      ),

      // Worker Available Requests
      GoRoute(
        path: '/worker-requests',
        name: 'worker-requests',
        builder: (context, state) => const WorkerRequestsPage(),
      ),

      // Service Request Detail (for workers)
      GoRoute(
        path: '/request/:id',
        name: 'request-detail',
        builder: (context, state) {
          final requestId = state.pathParameters['id'] ?? '';
          return ServiceRequestDetailPage(requestId: requestId);
        },
      ),

      // Worker Dashboard (now uses WorkerNavigation)
      GoRoute(
        path: '/worker-dashboard',
        name: 'worker-dashboard',
        builder: (context, state) => const WorkerNavigation(),
      ),

      // My Requests (for customers)
      GoRoute(
        path: '/my-requests',
        name: 'my-requests',
        builder: (context, state) => const MyRequestsPage(),
      ),

      // Main Navigation (Role-based)
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainNavigationPage(),
      ),

      // Role Selection
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleSelectionPage(),
      ),

      // Customer Navigation
      GoRoute(
        path: '/customer_home',
        builder: (context, state) => const CustomerNavigation(),
      ),

      // Worker Registration
      GoRoute(
        path: '/worker-register',
        builder: (context, state) => const WorkerRegistrationPage(),
      ),

      // Worker Login
      GoRoute(
        path: '/worker-login',
        builder: (context, state) => const WorkerLoginPage(),
      ),

      // Customer Login
      GoRoute(
        path: '/customer-login',
        builder: (context, state) => const CustomerLoginPage(),
      ),

      // Customer Registration
      GoRoute(
        path: '/customer-register',
        builder: (context, state) => const CustomerRegistrationPage(),
      ),

      // Email Verification
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) => const OtpVerificationPage(),
      ),

      // Jobs List
      GoRoute(
        path: '/jobs',
        name: 'jobs',
        builder: (context, state) => const JobPostingPage(),
      ),

// Messages
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const ConversationsListPage(),
      ),

      // Payments
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => const PaymentPage(jobId: ''),
      ),
    ],
  );
}
