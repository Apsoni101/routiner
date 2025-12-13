import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/extensions/string_extensions.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authUseCase}) : super(LoginUser.initial()) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<ResetValidationErrors>(_resetValidationErrors);
    on<ValidateAndLogin>(_validateAndLogin);
    on<OnGoogleLoginEvent>(_onGoogleLoginEvent);
  }

  AuthUseCase authUseCase;

  Future<void> _emailChanged(
    final EmailChanged event,
    final Emitter<LoginState> emit,
  ) async {
    final LoginState currentState = state;
    if (currentState is LoginUser) {
      final String newEmail = event.email.trim();
      final bool isValid = newEmail.isNotEmpty;
      final bool showError = !isValid && newEmail != currentState.email;

      emit(currentState.copyWith(emailValid: !showError, email: newEmail));
    }
  }

  Future<void> _passwordChanged(
    final PasswordChanged event,
    final Emitter<LoginState> emit,
  ) async {
    final LoginState currentState = state;
    if (currentState is LoginUser) {
      final bool isValid = event.password.trim().isNotEmpty;
      emit(
        currentState.copyWith(
          passwordValid: isValid,
          password: event.password.trim(),
        ),
      );
    }
  }

  Future<void> _resetValidationErrors(
    final ResetValidationErrors event,
    final Emitter<LoginState> emit,
  ) async {
    if (state is LoginUser) {
      emit(
        (state as LoginUser).copyWith(emailValid: true, passwordValid: true),
      );
    }
  }

  Future<void> _onGoogleLoginEvent(
    final OnGoogleLoginEvent event,
    final Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final Either<Failure, UserEntity> result = await authUseCase
        .signInWithGoogle();

    result.fold(
      (final Failure failure) => emit(LoginError(message: failure.message)),
      (final UserEntity user) => emit(LoginSuccess()),
    );
  }

  Future<void> _validateAndLogin(
    final ValidateAndLogin event,
    final Emitter<LoginState> emit,
  ) async {
    final LoginState currentState = state;
    if (currentState is LoginUser) {
      final String email = event.email;
      final String password = event.password;
      final bool emailValid = email.isValidEmail;
      final bool passwordValid = password.isValidPassword;

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

      final Either<Failure, UserEntity> result = await authUseCase
          .signInWithEmail(email, password);

      result.fold(
        (final Failure failure) => emit(LoginError(message: failure.message)),
        (final _) => emit(LoginSuccess()),
      );
    }
  }
}
