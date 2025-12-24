import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_remote_usecase.dart';

part 'activity_tab_event.dart';

part 'activity_tab_state.dart';

class ActivityTabBloc extends Bloc<ActivityTabEvent, ActivityTabState> {
  ActivityTabBloc({
    required this.profileLocalUseCase,
    required this.profileRemoteUseCase,
  }) : super(ActivityTabInitial()) {
    on<LoadActivities>(_onLoadActivities);
    on<RefreshActivities>(_onRefreshActivities);
  }

  final ProfileLocalUseCase profileLocalUseCase;
  final ProfileRemoteUseCase profileRemoteUseCase;

  // Cache for activities
  List<ActivityEntity>? _activitiesCache;
  DateTime? _activitiesCacheTime;
  static const Duration _cacheDuration = Duration(minutes: 2);

  bool _isCacheValid() {
    if (_activitiesCache == null || _activitiesCacheTime == null) {
      return false;
    }
    return DateTime.now().difference(_activitiesCacheTime!) < _cacheDuration;
  }

  void _invalidateCache() {
    _activitiesCache = null;
    _activitiesCacheTime = null;
  }

  // ============================================================================
  // LOAD ACTIVITIES (with caching)
  // ============================================================================

  Future<void> _onLoadActivities(
    final LoadActivities event,
    final Emitter<ActivityTabState> emit,
  ) async {
    // Check cache first
    if (_isCacheValid() && !event.forceRefresh) {
      final int totalPoints = await profileLocalUseCase.getTotalPoints();
      emit(
        ActivityTabLoaded(
          activities: _activitiesCache!,
          totalPoints: totalPoints,
        ),
      );
      return;
    }

    emit(ActivityTabLoading());

    // 1. Load from local storage (fast)
    final List<ActivityEntity> localActivities = await profileLocalUseCase
        .getActivities(limit: event.limit);
    final int localTotalPoints = await profileLocalUseCase.getTotalPoints();

    // Update cache
    _activitiesCache = localActivities;
    _activitiesCacheTime = DateTime.now();

    // 2. Emit local data immediately
    emit(
      ActivityTabLoaded(
        activities: localActivities,
        totalPoints: localTotalPoints,
      ),
    );

    // 3. Sync from remote in background (if requested)
    if (event.syncFromRemote) {
      final Either<Failure, List<ActivityEntity>> remoteActivitiesResult =
          await profileRemoteUseCase.getActivities(limit: event.limit);

      final Either<Failure, int> remoteTotalPointsResult =
          await profileRemoteUseCase.getTotalPoints();

      await remoteActivitiesResult.fold(
        (final Failure failure) async {
          // Remote fetch failed, keep showing local data
        },
        (final List<ActivityEntity> remoteActivities) async {
          // Update cache with remote data
          _activitiesCache = remoteActivities;
          _activitiesCacheTime = DateTime.now();

          // Get remote total points
          final int remotePoints = await remoteTotalPointsResult.fold(
            (final Failure failure) => localTotalPoints,
            (final int points) => points,
          );

          // Only emit if data is different
          if (remoteActivities.length != localActivities.length ||
              remotePoints != localTotalPoints) {
            if (!emit.isDone) {
              emit(
                ActivityTabLoaded(
                  activities: remoteActivities,
                  totalPoints: remotePoints,
                ),
              );
            }
          }
        },
      );
    }
  }

  // ============================================================================
  // REFRESH ACTIVITIES
  // ============================================================================

  Future<void> _onRefreshActivities(
    final RefreshActivities event,
    final Emitter<ActivityTabState> emit,
  ) async {
    // Invalidate cache
    _invalidateCache();

    // Keep current state while refreshing
    final ActivityTabState currentState = state;

    // Fetch from remote
    final Either<Failure, List<ActivityEntity>> remoteActivitiesResult =
        await profileRemoteUseCase.getActivities(limit: event.limit);

    final Either<Failure, int> remoteTotalPointsResult =
        await profileRemoteUseCase.getTotalPoints();

    await remoteActivitiesResult.fold(
      (final Failure failure) async {
        // If refresh fails, keep showing current data
        if (currentState is ActivityTabLoaded) {
          emit(
            currentState.copyWith(
              errorMessage: 'Failed to refresh: ${failure.message}',
            ),
          );
        } else {
          emit(ActivityTabError(message: failure.message));
        }
      },
      (final List<ActivityEntity> remoteActivities) async {
        // Update cache
        _activitiesCache = remoteActivities;
        _activitiesCacheTime = DateTime.now();

        final int remotePoints = await remoteTotalPointsResult.fold(
          (final Failure failure) async => profileLocalUseCase.getTotalPoints(),
          (final int points) => points,
        );

        emit(
          ActivityTabLoaded(
            activities: remoteActivities,
            totalPoints: remotePoints,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _invalidateCache();
    return super.close();
  }
}
