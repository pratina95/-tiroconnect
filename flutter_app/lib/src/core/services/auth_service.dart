import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Map<String, Object> buildUserProfileData({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String role,
  }) {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.toLowerCase(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // SIGN UP
  Future<User?> signUp(
    String email,
    String password, {
    String? fullName,
    String? phoneNumber,
    String role = 'customer',
    bool createUserProfile = false,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      developer.log("SIGNUP SUCCESS: ${cred.user?.email}");

      if (createUserProfile &&
          fullName != null &&
          phoneNumber != null &&
          fullName.trim().isNotEmpty &&
          phoneNumber.trim().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(
              buildUserProfileData(
                fullName: fullName.trim(),
                email: email.trim(),
                phoneNumber: phoneNumber.trim(),
                role: role,
              ),
            );
      }

      await cred.user!.sendEmailVerification(); // Email OTP

      return cred.user;
    } on FirebaseAuthException catch (e) {
      developer.log("FIREBASE SIGNUP ERROR CODE: ${e.code}");
      developer.log("MESSAGE: ${e.message}");
      return null;
    } catch (e, stack) {
      developer.log("UNKNOWN SIGNUP ERROR: $e", error: e, stackTrace: stack);
      return null;
    }
  }

  // LOGIN
  Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      developer.log("LOGIN SUCCESS: ${cred.user?.email}");

      return cred.user;
    } on FirebaseAuthException catch (e) {
      developer.log("FIREBASE LOGIN ERROR CODE: ${e.code}");
      developer.log("MESSAGE: ${e.message}");
      return null;
    } catch (e, stack) {
      developer.log("UNKNOWN LOGIN ERROR: $e", error: e, stackTrace: stack);
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    developer.log("LOGOUT SUCCESS");
  }
}
