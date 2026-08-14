part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class EmailVerificationSent extends AuthState {
  const EmailVerificationSent();
}

class EmailVerified extends AuthState {
  const EmailVerified();
}

class EmailNotVerified extends AuthState {
  const EmailNotVerified();
}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class UnauthenticatedError extends AuthState {
  final String message;

  const UnauthenticatedError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
