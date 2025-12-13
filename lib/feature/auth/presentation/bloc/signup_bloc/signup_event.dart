part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class NameChanged extends SignupEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object?> get props => <String?>[name];
}

final class SurnameChanged extends SignupEvent {
  const SurnameChanged({required this.surname});

  final String surname;

  @override
  List<Object?> get props => <String?>[surname];
}

final class BirthdateChanged extends SignupEvent {
  const BirthdateChanged({required this.birthdate});

  final String birthdate;

  @override
  List<Object?> get props => <String?>[birthdate];
}

final class EmailChanged extends SignupEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => <String?>[email];
}

final class PasswordChanged extends SignupEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object?> get props => <String?>[password];
}

class ValidateAndSignup extends SignupEvent {
  const ValidateAndSignup({
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.email,
    required this.password,
  });

  final String name;
  final String surname;
  final String birthdate;
  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[name, surname, birthdate, email, password];
}

class ResetValidationErrors extends SignupEvent {}

final class OnGoogleSignupEvent extends SignupEvent {
  const OnGoogleSignupEvent();

  @override
  List<Object?> get props => <Object>[];
}

class LogoutEvent extends SignupEvent {
  const LogoutEvent();
}