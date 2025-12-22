import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/extensions/string_extensions.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_local_usecase.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_remote_usecase.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required this.authRemoteUseCase, required this.authLocalUseCase})
    : super(SignupUser.initial()) {
    on<NameChanged>(_nameChanged);
    on<SurnameChanged>(_surnameChanged);
    on<BirthdateChanged>(_birthdateChanged);
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<ResetValidationErrors>(_resetValidationErrors);
    on<ValidateAndSignup>(_validateAndSignup);
    on<OnGoogleSignupEvent>(_onGoogleSignUpEvent);
  }

  final AuthRemoteUseCase authRemoteUseCase;
  final AuthLocalUseCase authLocalUseCase;

  // -------------------- Field Updates --------------------

  Future<void> _nameChanged(
    final NameChanged event,
    final Emitter<SignupState> emit,
  ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String name = event.name.trim();
      emit(currentState.copyWith(name: name, nameValid: name.isNotEmpty));
    }
  }

  Future<void> _surnameChanged(
    final SurnameChanged event,
    final Emitter<SignupState> emit,
  ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String surname = event.surname.trim();
      emit(
        currentState.copyWith(
          surname: surname,
          surnameValid: surname.isNotEmpty,
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
      final String birthdate = event.birthdate.trim();
      emit(
        currentState.copyWith(
          birthdate: birthdate,
          birthdateValid: birthdate.isNotEmpty && birthdate.length == 8,
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
      final String email = event.email.trim();
      emit(currentState.copyWith(email: email, emailValid: email.isValidEmail));
    }
  }

  Future<void> _passwordChanged(
    final PasswordChanged event,
    final Emitter<SignupState> emit,
  ) async {
    final SignupState currentState = state;
    if (currentState is SignupUser) {
      final String password = event.password.trim();
      emit(
        currentState.copyWith(
          password: password,
          passwordValid: password.isValidPassword,
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

  /// -------------------- Signup Flow --------------------

  Future<void> _validateAndSignup(
    final ValidateAndSignup event,
    final Emitter<SignupState> emit,
  ) async {
    final SignupState currentState = state;
    if (currentState is! SignupUser) {
      return;
    }

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

    if (!nameValid ||
        !surnameValid ||
        !birthdateValid ||
        !emailValid ||
        !passwordValid) {
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

    final Either<Failure, UserEntity> result = await authRemoteUseCase
        .signUpWithEmailAndData(email, password, name, surname, birthdate);

    await result.fold(
      (final Failure failure) async {
        emit(
          SignupUser(
            name: name,
            surname: surname,
            birthdate: birthdate,
            email: email,
            password: password,
            nameValid: true,
            surnameValid: true,
            birthdateValid: true,
            emailValid: true,
            passwordValid: true,
          ),
        );

        emit(SignupError(message: failure.message));
      },
      (final UserEntity user) async {
        await authLocalUseCase.saveUserCredentials(user);
        emit(SignupSuccess());
      },
    );
  }

  /// -------------------- Google Signup --------------------

  Future<void> _onGoogleSignUpEvent(
    final OnGoogleSignupEvent event,
    final Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    final Either<Failure, UserEntity> result = await authRemoteUseCase
        .signInWithGoogle();

    await result.fold(
      (final Failure failure) async {
        emit(SignupError(message: failure.message));
      },
      (final UserEntity user) async {
        await authLocalUseCase.saveUserCredentials(user);
        emit(SignupSuccess());
      },
    );
  }
}
