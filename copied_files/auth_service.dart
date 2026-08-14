import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN UP
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print("SIGNUP SUCCESS: ${cred.user?.email}");

      await cred.user!.sendEmailVerification(); // Email OTP

      return cred.user;
    } on FirebaseAuthException catch (e) {
      print("FIREBASE SIGNUP ERROR CODE: ${e.code}");
      print("MESSAGE: ${e.message}");
      return null;
    } catch (e, stack) {
      print("UNKNOWN SIGNUP ERROR: $e");
      print(stack);
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

      print("LOGIN SUCCESS: ${cred.user?.email}");

      return cred.user;
    } on FirebaseAuthException catch (e) {
      print("FIREBASE LOGIN ERROR CODE: ${e.code}");
      print("MESSAGE: ${e.message}");
      return null;
    } catch (e, stack) {
      print("UNKNOWN LOGIN ERROR: $e");
      print(stack);
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
    print("LOGOUT SUCCESS");
  }
}
