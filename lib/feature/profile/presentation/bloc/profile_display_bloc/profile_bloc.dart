import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_remote_usecase.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.profileRemoteUseCase,
    required this.profileLocalUseCase,
  }) : super(const ProfileInitial()) {
    on<LoadCurrentUserProfile>(_onLoadCurrentUserProfile);
    on<LoadProfile>(_onLoadProfile);
    on<RefreshCurrentUserProfile>(_onRefreshCurrentUserProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<LoadActivities>(_onLoadActivities);
    on<LoadTotalPoints>(_onLoadTotalPoints);
    on<LoadAchievements>(_onLoadAchievements);
    on<UnlockAchievement>(_onUnlockAchievement);
    on<InitializeAchievements>(_onInitializeAchievements);
    on<ClearProfileCache>(_onClearProfileCache);
  }

  final ProfileRemoteUseCase profileRemoteUseCase;
  final ProfileLocalUseCase profileLocalUseCase;

  /// Load the current authenticated user's profile
  Future<void> _onLoadCurrentUserProfile(
      final LoadCurrentUserProfile event,
      final Emitter<ProfileState> emit,
      ) async {
    final UserEntity? currentUser = profileLocalUseCase.getCurrentUser();

    if (currentUser?.uid == null) {
      emit(const ProfileError(message: 'No user logged in'));
      return;
    }

    await _onLoadProfile(LoadProfile(uid: currentUser!.uid!), emit);
  }

  /// Load a specific user's profile by UID
  Future<void> _onLoadProfile(
      final LoadProfile event,
      final Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    // First try to load from cache
    final UserEntity? cachedProfile = profileLocalUseCase.getCachedProfile();
    final int cachedPoints = await profileLocalUseCase.getTotalPoints();

    if (cachedProfile != null) {
      emit(ProfileLoaded(profile: cachedProfile, totalPoints: cachedPoints));
    }

    // Then fetch from remote
    final Either<Failure, UserEntity> result = await profileRemoteUseCase
        .getUserProfile(event.uid);

    await result.fold(
          (final Failure failure) async {
        if (cachedProfile != null) {
          return;
        }
        emit(ProfileError(message: failure.message));
      },
          (final UserEntity profile) async {
        await profileLocalUseCase.cacheProfile(profile);

        final Either<Failure, int> pointsResult = await profileRemoteUseCase
            .getTotalPoints();
        final int points = pointsResult.fold(
              (final Failure failure) => cachedPoints,
              (final int remotePoints) => remotePoints,
        );

        // Cache points locally
        await profileLocalUseCase.cacheTotalPoints(points);

        emit(ProfileLoaded(profile: profile, totalPoints: points));
      },
    );
  }

  /// Refresh the current authenticated user's profile
  Future<void> _onRefreshCurrentUserProfile(
      final RefreshCurrentUserProfile event,
      final Emitter<ProfileState> emit,
      ) async {
    final UserEntity? currentUser = profileLocalUseCase.getCurrentUser();

    if (currentUser?.uid == null) {
      emit(const ProfileError(message: 'No user logged in'));
      return;
    }

    await _onRefreshProfile(RefreshProfile(uid: currentUser!.uid!), emit);
  }

  /// Refresh a specific user's profile by UID
  Future<void> _onRefreshProfile(
      final RefreshProfile event,
      final Emitter<ProfileState> emit,
      ) async {
    final ProfileState currentState = state;

    final Either<Failure, UserEntity> result = await profileRemoteUseCase
        .getUserProfile(event.uid);

    await result.fold(
          (final Failure failure) async {
        if (currentState is ProfileLoaded) {
          return;
        }
        emit(ProfileError(message: failure.message));
      },
          (final UserEntity profile) async {
        await profileLocalUseCase.cacheProfile(profile);

        // Fetch latest points
        final Either<Failure, int> pointsResult = await profileRemoteUseCase
            .getTotalPoints();
        final int points = pointsResult.fold(
              (final Failure failure) =>
          (currentState is ProfileLoaded) ? currentState.totalPoints ?? 0 : 0,
              (final int remotePoints) => remotePoints,
        );

        // Cache points locally
        await profileLocalUseCase.cacheTotalPoints(points);

        emit(ProfileLoaded(
          profile: profile,
          totalPoints: points,
          activities:
          (currentState is ProfileLoaded) ? currentState.activities : null,
          achievements:
          (currentState is ProfileLoaded) ? currentState.achievements : null,
        ));
      },
    );
  }

  /// Update the user's profile
  Future<void> _onUpdateProfile(
      final UpdateProfile event,
      final Emitter<ProfileState> emit,
      ) async {
    final ProfileState currentState = state;
    emit(const ProfileUpdating());

    final Either<Failure, Unit> result = await profileRemoteUseCase
        .updateUserProfile(event.profile);

    await result.fold(
          (final Failure failure) async {
        emit(ProfileUpdateError(message: failure.message));

        if (currentState is ProfileLoaded) {
          emit(currentState);
        }
      },
          (_) async {
        await profileLocalUseCase.cacheProfile(event.profile);
        emit(ProfileUpdateSuccess(profile: event.profile));

        emit(ProfileLoaded(profile: event.profile));
      },
    );
  }

  /// Load activities for the current user - Show local first, fetch remote in background
  Future<void> _onLoadActivities(
      final LoadActivities event,
      final Emitter<ProfileState> emit,
      ) async {
    // Get local activities first
    final List<ActivityEntity> localActivities = await profileLocalUseCase
        .getActivities(limit: event.limit);
    print('[ProfileBloc] _onLoadActivities - Local activities count: ${localActivities.length}');

    // Emit local data immediately
    if (localActivities.isNotEmpty) {
      print('[ProfileBloc] _onLoadActivities - Emitting local activities');
      emit(ActivitiesLoaded(activities: localActivities));
    } else {
      print('[ProfileBloc] _onLoadActivities - No local activities, showing loading');
      emit(const ActivitiesLoading());
    }

    // Fetch from remote in background
    print('[ProfileBloc] _onLoadActivities - Fetching from remote...');
    final Either<Failure, List<ActivityEntity>> result =
    await profileRemoteUseCase.getActivities(limit: event.limit);

    await result.fold(
          (final Failure failure) async {
        print('[ProfileBloc] _onLoadActivities - Remote fetch failed: ${failure.message}');
        // Keep showing local data, don't emit error if we have local data
        if (localActivities.isEmpty) {
          emit(ActivitiesError(message: failure.message));
        }
      },
          (final List<ActivityEntity> activities) async {
        print('[ProfileBloc] _onLoadActivities - Remote activities count: ${activities.length}');
        print('[ProfileBloc] _onLoadActivities - Data changed: ${activities.length != localActivities.length}');

        // Only emit if data changed
        if (activities.length != localActivities.length ||
            !_listEquals(activities, localActivities)) {
          print('[ProfileBloc] _onLoadActivities - Activities changed! Emitting new state');
          emit(ActivitiesLoaded(activities: activities));

          // Update profile state if exists
          if (state is ProfileLoaded) {
            final UserEntity currentProfile = (state as ProfileLoaded).profile;
            print('[ProfileBloc] _onLoadActivities - Updating profile state with new activities');
            emit(ProfileLoaded(profile: currentProfile, activities: activities));
          }
        } else {
          print('[ProfileBloc] _onLoadActivities - Activities are the same, skipping emit');
        }
      },
    );
  }

  /// Load total points for the current user - Fetch from remote and update if different
  Future<void> _onLoadTotalPoints(
      final LoadTotalPoints event,
      final Emitter<ProfileState> emit,
      ) async {
    // Get local points first
    final int localPoints = await profileLocalUseCase.getTotalPoints();
    print('[ProfileBloc] _onLoadTotalPoints - Local points: $localPoints');

    // Emit local points immediately if we have a loaded profile
    if (state is ProfileLoaded) {
      final UserEntity currentProfile = (state as ProfileLoaded).profile;
      final List<ActivityEntity>? currentActivities =
          (state as ProfileLoaded).activities;
      final List<AchievementEntity>? currentAchievements =
          (state as ProfileLoaded).achievements;

      print('[ProfileBloc] _onLoadTotalPoints - Emitting local points: $localPoints');
      emit(
        ProfileLoaded(
          profile: currentProfile,
          totalPoints: localPoints,
          activities: currentActivities,
          achievements: currentAchievements,
        ),
      );
    }

    // Fetch from remote
    print('[ProfileBloc] _onLoadTotalPoints - Fetching from remote...');
    final Either<Failure, int> result = await profileRemoteUseCase
        .getTotalPoints();

    await result.fold(
          (final Failure failure) async {
        print('[ProfileBloc] _onLoadTotalPoints - Remote fetch failed: ${failure.message}');
        // Keep using local points, don't emit error
      },
          (final int remotePoints) async {
        print('[ProfileBloc] _onLoadTotalPoints - Remote points: $remotePoints, Local points: $localPoints');

        // If remote points are different from local, update local and emit
        if (remotePoints != localPoints) {
          print('[ProfileBloc] _onLoadTotalPoints - Points differ! Remote: $remotePoints vs Local: $localPoints');
          print('[ProfileBloc] _onLoadTotalPoints - Updating local storage with remote points...');

          // Update local storage with remote points
          await profileLocalUseCase.cacheTotalPoints(remotePoints);

          // Emit updated state if we have a loaded profile
          if (state is ProfileLoaded) {
            final UserEntity currentProfile = (state as ProfileLoaded).profile;
            final List<ActivityEntity>? currentActivities =
                (state as ProfileLoaded).activities;
            final List<AchievementEntity>? currentAchievements =
                (state as ProfileLoaded).achievements;

            print('[ProfileBloc] _onLoadTotalPoints - Emitting updated points: $remotePoints');
            emit(
              ProfileLoaded(
                profile: currentProfile,
                totalPoints: remotePoints,
                activities: currentActivities,
                achievements: currentAchievements,
              ),
            );
          }
        } else {
          print('[ProfileBloc] _onLoadTotalPoints - Points are same, no update needed');
        }
      },
    );
  }

  /// Load achievements for the current user - Show local first, fetch remote in background
  Future<void> _onLoadAchievements(
      final LoadAchievements event,
      final Emitter<ProfileState> emit,
      ) async {
    // Get local achievements first
    final List<AchievementEntity> localAchievements = await profileLocalUseCase
        .getAchievements();
    print('[ProfileBloc] _onLoadAchievements - Local achievements count: ${localAchievements.length}');

    // Emit local data immediately
    if (localAchievements.isNotEmpty) {
      print('[ProfileBloc] _onLoadAchievements - Emitting local achievements');
      emit(AchievementsLoaded(achievements: localAchievements));
    } else {
      print('[ProfileBloc] _onLoadAchievements - No local achievements, showing loading');
      emit(const AchievementsLoading());
    }

    // Fetch from remote in background
    print('[ProfileBloc] _onLoadAchievements - Fetching from remote...');
    final Either<Failure, List<AchievementEntity>> result =
    await profileRemoteUseCase.getAchievements();

    await result.fold(
          (final Failure failure) async {
        print('[ProfileBloc] _onLoadAchievements - Remote fetch failed: ${failure.message}');
        // Keep showing local data, don't emit error if we have local data
        if (localAchievements.isEmpty) {
          emit(AchievementsError(message: failure.message));
        }
      },
          (final List<AchievementEntity> achievements) async {
        print('[ProfileBloc] _onLoadAchievements - Remote achievements count: ${achievements.length}');
        print('[ProfileBloc] _onLoadAchievements - Data changed: ${achievements.length != localAchievements.length}');

        // Only emit if data changed
        if (achievements.length != localAchievements.length ||
            !_listEquals(achievements, localAchievements)) {
          print('[ProfileBloc] _onLoadAchievements - Achievements changed! Saving and emitting new state');
          // Save to local cache
          await profileLocalUseCase.saveAchievements(achievements);
          emit(AchievementsLoaded(achievements: achievements));

          // Update current profile state if exists
          if (state is ProfileLoaded) {
            final UserEntity currentProfile = (state as ProfileLoaded).profile;
            print('[ProfileBloc] _onLoadAchievements - Updating profile state with new achievements');
            emit(
              ProfileLoaded(profile: currentProfile, achievements: achievements),
            );
          }
        } else {
          print('[ProfileBloc] _onLoadAchievements - Achievements are the same, skipping emit');
        }
      },
    );
  }

  /// Unlock a specific achievement
  Future<void> _onUnlockAchievement(
      final UnlockAchievement event,
      final Emitter<ProfileState> emit,
      ) async {
    final Either<Failure, Unit> result = await profileRemoteUseCase
        .unlockAchievement(event.achievementId);

    await result.fold(
          (final Failure failure) async {
        emit(AchievementsError(message: failure.message));
      },
          (_) async {
        // Reload achievements after unlocking
        final Either<Failure, List<AchievementEntity>> achievementsResult =
        await profileRemoteUseCase.getAchievements();

        await achievementsResult.fold(
              (final Failure failure) async {
            emit(AchievementsError(message: failure.message));
          },
              (final List<AchievementEntity> achievements) async {
            await profileLocalUseCase.saveAchievements(achievements);
            emit(
              AchievementUnlocked(
                achievementId: event.achievementId,
                achievements: achievements,
              ),
            );

            // Update profile state
            if (state is ProfileLoaded) {
              final UserEntity currentProfile =
                  (state as ProfileLoaded).profile;
              emit(
                ProfileLoaded(
                  profile: currentProfile,
                  achievements: achievements,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Initialize achievements for the current user
  Future<void> _onInitializeAchievements(
      final InitializeAchievements event,
      final Emitter<ProfileState> emit,
      ) async {
    final Either<Failure, Unit> result = await profileRemoteUseCase
        .initializeAchievements();

    result.fold(
          (final Failure failure) {
        emit(AchievementsError(message: failure.message));
      },
          (_) {
        emit(const AchievementsInitialized());

        // Reload achievements after initialization
        add(const LoadAchievements());
      },
    );
  }

  /// Clear cached profile data
  Future<void> _onClearProfileCache(
      final ClearProfileCache event,
      final Emitter<ProfileState> emit,
      ) async {
    await profileLocalUseCase.clearCachedProfile();
    await profileLocalUseCase.clearAchievements();

    emit(const ProfileInitial());
  }

  /// Helper method to compare lists
  bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}