import 'package:cloud_firestore/cloud_firestore.dart';

String getDestinationForRole(String? role) {
  switch ((role ?? '').trim().toLowerCase()) {
    case 'worker':
      return '/worker-dashboard';
    case 'customer':
      return '/customer_home';
    case 'business':
      return '/business-dashboard';
    case 'admin':
      return '/admin-dashboard';
    default:
      return '/role';
  }
}

Future<String> resolveDestinationForUser({
  required FirebaseFirestore firestore,
  required String userId,
}) async {
  final userDoc = await firestore.collection('users').doc(userId).get();
  final role = userDoc.data()?['role'] as String?;
  final resolvedRole = getDestinationForRole(role);
  if (resolvedRole != '/role') {
    return resolvedRole;
  }

  final customerDoc = await firestore.collection('customers').doc(userId).get();
  if (customerDoc.exists) {
    return '/customer_home';
  }

  final workerDoc = await firestore.collection('workers').doc(userId).get();
  if (workerDoc.exists) {
    return '/worker-dashboard';
  }

  return '/role';
}
