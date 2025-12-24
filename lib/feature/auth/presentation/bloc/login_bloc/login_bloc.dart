import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/extensions/string_extensions.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_local_usecase.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_remote_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authRemoteUseCase, required this.authLocalUseCase})
    : super(LoginUser.initial()) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<ResetValidationErrors>(_resetValidationErrors);
    on<ValidateAndLogin>(_validateAndLogin);
    on<OnGoogleLoginEvent>(_onGoogleLoginEvent);
  }

  final AuthRemoteUseCase authRemoteUseCase;
  final AuthLocalUseCase authLocalUseCase;

  // -------------------- Field Updates --------------------

  Future<void> _emailChanged(
    EmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state;
    if (currentState is LoginUser) {
      final email = event.email.trim();

      emit(
        currentState.copyWith(
          email: email,
          emailValid: email.isValidEmail || email.isEmpty,
        ),
      );
    }
  }

  Future<void> _passwordChanged(
    PasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state;
    if (currentState is LoginUser) {
      final password = event.password.trim();

      emit(
        currentState.copyWith(
          password: password,
          passwordValid: password.isNotEmpty,
        ),
      );
    }
  }

  Future<void> _resetValidationErrors(
    ResetValidationErrors event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginUser) {
      emit(
        (state as LoginUser).copyWith(emailValid: true, passwordValid: true),
      );
    }
  }

  // -------------------- Email & Password Login --------------------

  Future<void> _validateAndLogin(
    ValidateAndLogin event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LoginUser) return;

    final email = event.email.trim();
    final password = event.password.trim();

    final emailValid = email.isValidEmail;
    final passwordValid = password.isValidPassword;

    if (!emailValid || !passwordValid) {
      emit(
        currentState.copyWith(
          email: email,
          password: password,
          emailValid: emailValid,
          passwordValid: passwordValid,
        ),
      );
      return;
    }

    emit(LoginLoading());

    /// 1️⃣ Remote login
    final Either<Failure, UserEntity> result = await authRemoteUseCase
        .signInWithEmail(email, password);

    await result.fold(
      (failure) async {
        // Emit error first for BlocListener to show SnackBar
        emit(LoginError(message: failure.message));

        // Then immediately transition back to LoginUser state
        // This keeps the form data and re-enables the login button
        emit(
          LoginUser(
            email: email,
            password: password,
            emailValid: true,
            passwordValid: true,
          ),
        );
      },
      (user) async {
        await authLocalUseCase.saveUserCredentials(user);

        emit(LoginSuccess());
      },
    );
  }

  // -------------------- Google Login --------------------

  Future<void> _onGoogleLoginEvent(
    OnGoogleLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    /// 1️⃣ Remote Google login
    final Either<Failure, UserEntity> result = await authRemoteUseCase
        .signInWithGoogle();

    await result.fold(
      (failure) async {
        // Emit error first
        emit(LoginError(message: failure.message));

        // Then transition back to initial state
        emit(LoginUser.initial());
      },
      (user) async {
        /// 2️⃣ Save user locally
        await authLocalUseCase.saveUserCredentials(user);

        /// 3️⃣ Success
        emit(LoginSuccess());
      },
    );
  }
}
