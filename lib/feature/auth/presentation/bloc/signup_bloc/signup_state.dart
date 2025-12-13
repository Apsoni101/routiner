part of 'signup_bloc.dart';

@immutable
sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupUser extends SignupState {
  const SignupUser({
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.email,
    required this.password,
    required this.nameValid,
    required this.surnameValid,
    required this.birthdateValid,
    required this.emailValid,
    required this.passwordValid,
  });

  factory SignupUser.initial() => const SignupUser(
    name: '',
    surname: '',
    birthdate: '',
    email: '',
    password: '',
    nameValid: true,
    surnameValid: true,
    birthdateValid: true,
    emailValid: true,
    passwordValid: true,
  );

  final String name;
  final String surname;
  final String birthdate;
  final String email;
  final String password;
  final bool nameValid;
  final bool surnameValid;
  final bool birthdateValid;
  final bool emailValid;
  final bool passwordValid;

  SignupUser copyWith({
    final String? name,
    final String? surname,
    final String? birthdate,
    final String? email,
    final String? password,
    final bool? nameValid,
    final bool? surnameValid,
    final bool? birthdateValid,
    final bool? emailValid,
    final bool? passwordValid,
  }) => SignupUser(
    name: name ?? this.name,
    surname: surname ?? this.surname,
    birthdate: birthdate ?? this.birthdate,
    email: email ?? this.email,
    password: password ?? this.password,
    nameValid: nameValid ?? this.nameValid,
    surnameValid: surnameValid ?? this.surnameValid,
    birthdateValid: birthdateValid ?? this.birthdateValid,
    emailValid: emailValid ?? this.emailValid,
    passwordValid: passwordValid ?? this.passwordValid,
  );

  @override
  List<Object?> get props => <Object?>[
    name,
    surname,
    birthdate,
    email,
    password,
    nameValid,
    surnameValid,
    birthdateValid,
    emailValid,
    passwordValid,
  ];
}

final class SignupError extends SignupState {
  const SignupError({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}