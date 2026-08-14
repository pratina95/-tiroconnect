part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignUpWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SendEmailVerification extends AuthEvent {
  const SendEmailVerification();
}

class CheckEmailVerified extends AuthEvent {
  const CheckEmailVerified();
}

class RegisterCustomer extends AuthEvent {
  final RegisterCustomerRequest request;

  const RegisterCustomer(this.request);

  @override
  List<Object> get props => [request];
}

class RegisterWorker extends AuthEvent {
  final RegisterWorkerRequest request;

  const RegisterWorker(this.request);

  @override
  List<Object> get props => [request];
}

class RegisterBusiness extends AuthEvent {
  final RegisterBusinessRequest request;

  const RegisterBusiness(this.request);

  @override
  List<Object> get props => [request];
}

class Logout extends AuthEvent {
  const Logout();
}
