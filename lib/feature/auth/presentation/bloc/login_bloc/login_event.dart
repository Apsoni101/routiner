part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => <Object>[];
}

final class EmailChanged extends LoginEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => <String?>[email];
}

final class PasswordChanged extends LoginEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object?> get props => <String?>[password];
}

class ValidateAndLogin extends LoginEvent {
  const ValidateAndLogin({required this.email, required this.password});
  final String email;
  final String password;
}

class ResetValidationErrors extends LoginEvent {}

final class OnGoogleLoginEvent extends LoginEvent {
  const OnGoogleLoginEvent();
  @override
  List<Object?> get props => <Object>[];
}

class LogoutEvent extends LoginEvent {
  const LogoutEvent();
}
