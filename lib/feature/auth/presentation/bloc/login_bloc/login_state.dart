part of 'login_bloc.dart';

@immutable
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object>[];
}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginUser extends LoginState {
  const LoginUser({
    required this.email,
    required this.password,
    required this.passwordValid,
    required this.emailValid,
  });

  factory LoginUser.initial() => const LoginUser(
    email: '',
    password: '',
    passwordValid: true,
    emailValid: true,
  );

  final String email;
  final String password;
  final bool passwordValid;
  final bool emailValid;

  LoginUser copyWith({
    final String? email,
    final String? password,
    final bool? passwordValid,
    final bool? emailValid,
  }) => LoginUser(
    email: email ?? this.email,
    password: password ?? this.password,
    passwordValid: passwordValid ?? this.passwordValid,
    emailValid: emailValid ?? this.emailValid,
  );

  @override
  List<Object?> get props => <Object?>[
    email,
    password,
    passwordValid,
    emailValid,
  ];
}

final class LoginError extends LoginState {
  const LoginError({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
