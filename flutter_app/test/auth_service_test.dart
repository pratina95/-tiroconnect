import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiroconnect/src/core/services/auth_service.dart';

void main() {
  group('AuthService user profile payload', () {
    test('builds a Firestore payload for worker registration', () {
      final payload = AuthService.buildUserProfileData(
        fullName: 'Katse',
        email: 'katse@gmail.com',
        phoneNumber: '71234567',
        role: 'worker',
      );

      expect(payload['fullName'], 'Katse');
      expect(payload['email'], 'katse@gmail.com');
      expect(payload['phoneNumber'], '71234567');
      expect(payload['role'], 'worker');
      expect(payload['createdAt'], isA<FieldValue>());
    });
  });
}
