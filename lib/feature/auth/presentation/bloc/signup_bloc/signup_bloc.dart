import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/extensions/string_extensions.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required this.authUseCase}) : super(SignupUser.initial()) {
    on<NameChanged>(_nameChanged);
    on<SurnameChanged>(_surnameChanged);
    on<BirthdateChanged>(_birthdateChanged);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<ResetValidationErrors>(_resetValidationErrors);
    on<ValidateAndSignup>(_validateAndSignup);
    on<OnGoogleSignupEvent>(_onGoogleSignUpEvent);
  }

  final AuthUseCase authUseCase;

  Future<void> _nameChanged(
      final NameChanged event,
      final Emitter<SignupState> emit,
      ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String newName = event.name.trim();
      final bool isValid = newName.isNotEmpty;

      emit(
        currentState.copyWith(
          nameValid: isValid,
          name: newName,
        ),
      );
    }
  }

  Future<void> _surnameChanged(
      final SurnameChanged event,
      final Emitter<SignupState> emit,
      ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String newSurname = event.surname.trim();
      final bool isValid = newSurname.isNotEmpty;

      emit(
        currentState.copyWith(
          surnameValid: isValid,
          surname: newSurname,
        ),
      );
    }
  }

  Future<void> _birthdateChanged(
      final BirthdateChanged event,
      final Emitter<SignupState> emit,
      ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String newBirthdate = event.birthdate.trim();
      // Validate birthdate format (DD/MM/YY) and length
      final bool isValid = newBirthdate.isNotEmpty && newBirthdate.length == 8;

      emit(
        currentState.copyWith(
          birthdateValid: isValid,
          birthdate: newBirthdate,
        ),
      );
    }
  }

  Future<void> _emailChanged(
      final EmailChanged event,
      final Emitter<SignupState> emit,
      ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String newEmail = event.email.trim();
      final bool isValid = newEmail.isNotEmpty;

      emit(
        currentState.copyWith(
          emailValid: isValid,
          email: newEmail,
        ),
      );
    }
  }

  Future<void> _passwordChanged(
      final PasswordChanged event,
      final Emitter<SignupState> emit,
      ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String newPassword = event.password.trim();
      final bool isValid = newPassword.isNotEmpty;

      emit(
        currentState.copyWith(
          passwordValid: isValid,
          password: newPassword,
        ),
      );
    }
  }

  Future<void> _resetValidationErrors(
      final ResetValidationErrors event,
      final Emitter<SignupState> emit,
      ) async {
    if (state is SignupUser) {
      emit(
        (state as SignupUser).copyWith(
          nameValid: true,
          surnameValid: true,
          birthdateValid: true,
          emailValid: true,
          passwordValid: true,
        ),
      );
    }
  }

  Future<void> _validateAndSignup(
      final ValidateAndSignup event,
      final Emitter<SignupState> emit,
      ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String name = event.name.trim();
      final String surname = event.surname.trim();
      final String birthdate = event.birthdate.trim();
      final String email = event.email.trim();
      final String password = event.password.trim();

      final bool nameValid = name.isNotEmpty;
      final bool surnameValid = surname.isNotEmpty;
      final bool birthdateValid = birthdate.isNotEmpty && birthdate.length == 8;
      final bool emailValid = email.isValidEmail;
      final bool passwordValid = password.isValidPassword;

      if (!nameValid || !surnameValid || !birthdateValid || !emailValid || !passwordValid) {
        emit(
          currentState.copyWith(
            name: name,
            surname: surname,
            birthdate: birthdate,
            email: email,
            password: password,
            nameValid: nameValid,
            surnameValid: surnameValid,
            birthdateValid: birthdateValid,
            emailValid: emailValid,
            passwordValid: passwordValid,
          ),
        );
        return;
      }

      emit(SignupLoading());

      final Either<Failure, UserEntity> result = await authUseCase
          .signUpWithEmail(email, password);

      result.fold(
            (final Failure failure) => emit(SignupError(message: failure.message)),
            (final _) => emit(SignupSuccess()),
      );
    }
  }

  Future<void> _onGoogleSignUpEvent(
      final OnGoogleSignupEvent event,
      final Emitter<SignupState> emit,
      ) async {
    emit(SignupLoading());

    final Either<Failure, UserEntity> result = await authUseCase
        .signInWithGoogle();

    result.fold(
          (final Failure failure) => emit(SignupError(message: failure.message)),
          (final UserEntity user) => emit(SignupSuccess()),
    );
  }
}