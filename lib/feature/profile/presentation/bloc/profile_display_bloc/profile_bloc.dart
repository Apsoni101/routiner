// presentation/bloc/profile_bloc/profile_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_remote_usecase.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.profileRemoteUseCase,
    required this.profileLocalUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  final ProfileRemoteUseCase profileRemoteUseCase;
  final ProfileLocalUseCase profileLocalUseCase;

  Future<void> _onLoadProfile(
    final LoadProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // First try to load from cache
    final UserEntity? cachedProfile = profileLocalUseCase.getCachedProfile();

    if (cachedProfile != null) {
      emit(ProfileLoaded(profile: cachedProfile));
    }

    // Then fetch from remote
    final Either<Failure, UserEntity> result = await profileRemoteUseCase
        .getUserProfile(event.uid);

    await result.fold(
      (final Failure failure) async {
        // If we have cached data, keep showing it
        if (cachedProfile != null) {
          // Don't emit error if we have cached data
          return;
        }
        emit(ProfileError(message: failure.message));
      },
      (final UserEntity profile) async {
        // Cache the profile
        await profileLocalUseCase.cacheProfile(profile);
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> _onRefreshProfile(
    final RefreshProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    // Keep current state while refreshing
    final currentState = state;

    final Either<Failure, UserEntity> result = await profileRemoteUseCase
        .getUserProfile(event.uid);

    await result.fold(
      (final Failure failure) async {
        // Keep showing current data if refresh fails
        if (currentState is ProfileLoaded) {
          return;
        }
        emit(ProfileError(message: failure.message));
      },
      (final UserEntity profile) async {
        await profileLocalUseCase.cacheProfile(profile);
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> _onUpdateProfile(
    final UpdateProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    emit(ProfileLoading());

    final Either<Failure, Unit> result = await profileRemoteUseCase
        .updateUserProfile(event.profile);

    await result.fold(
      (final Failure failure) async {
        emit(ProfileError(message: failure.message));

        // Restore previous state
        if (currentState is ProfileLoaded) {
          emit(currentState);
        }
      },
      (final Unit _) async {
        await profileLocalUseCase.cacheProfile(event.profile);
        emit(ProfileLoaded(profile: event.profile));
      },
    );
  }
}
