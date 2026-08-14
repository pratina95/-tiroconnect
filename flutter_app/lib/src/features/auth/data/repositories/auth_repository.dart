import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/auth/data/models/user_model.dart';
import 'package:tiroconnect/src/features/auth/data/models/register_requests.dart';
import 'package:tiroconnect/src/core/services/firebase_service.dart';
import 'package:tiroconnect/src/core/services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  });
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerified();
  Future<UserModel> registerCustomer(RegisterCustomerRequest request);
  Future<UserModel> registerWorker(RegisterWorkerRequest request);
  Future<UserModel> registerBusiness(RegisterBusinessRequest request);
  Future<void> logout();
  Future<String?> getIdToken();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;
  final ApiService _apiService;

  AuthRepositoryImpl(this._firebaseService, this._apiService);

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseService.currentUser;
    if (firebaseUser == null) return null;

    // Fetch user data from Firestore
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;

      // Convert role string to UserRole enum
      UserRole role;
      switch (data['role'] as String?) {
        case 'worker':
          role = UserRole.worker;
          break;
        case 'business':
          role = UserRole.business;
          break;
        case 'admin':
          role = UserRole.admin;
          break;
        default:
          role = UserRole.customer;
      }

      return UserModel(
        id: firebaseUser.uid,
        fullName: data['fullName'] as String? ?? '',
        phoneNumber: data['phoneNumber'] as String? ?? '',
        email: data['email'] as String?,
        role: role,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    // This is handled in AuthService directly
    // Return a temporary user model
    return UserModel(
      id: _firebaseService.currentUser?.uid ?? '',
      fullName: '',
      phoneNumber: '',
      email: email,
      role: UserRole.customer,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // This is handled in AuthService directly
    // Fetch user data from Firestore
    final firebaseUser = _firebaseService.currentUser;
    if (firebaseUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Convert role string to UserRole enum
        UserRole role;
        switch (data['role'] as String?) {
          case 'worker':
            role = UserRole.worker;
            break;
          case 'business':
            role = UserRole.business;
            break;
          case 'admin':
            role = UserRole.admin;
            break;
          default:
            role = UserRole.customer;
        }

        return UserModel(
          id: firebaseUser.uid,
          fullName: data['fullName'] as String? ?? '',
          phoneNumber: data['phoneNumber'] as String? ?? '',
          email: data['email'] as String?,
          role: role,
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }
    }

    return UserModel(
      id: firebaseUser?.uid ?? '',
      fullName: '',
      phoneNumber: '',
      email: email,
      role: UserRole.customer,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseService.sendEmailVerification();
  }

  @override
  Future<bool> checkEmailVerified() async {
    await _firebaseService.reloadUser();
    return _firebaseService.isEmailVerified;
  }

  @override
  Future<UserModel> registerCustomer(RegisterCustomerRequest request) async {
    final response = await _apiService.registerCustomer(request.toJson());
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> registerWorker(RegisterWorkerRequest request) async {
    final response = await _apiService.registerWorker(request.toJson());
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> registerBusiness(RegisterBusinessRequest request) async {
    final response = await _apiService.registerBusiness(request.toJson());
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await _firebaseService.signOut();
  }

  @override
  Future<String?> getIdToken() async {
    return await _firebaseService.getIdToken();
  }
}
