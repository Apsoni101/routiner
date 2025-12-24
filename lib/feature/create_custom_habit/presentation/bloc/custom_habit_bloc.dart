// ============================================================================
// COMPLETE CUSTOM HABIT BLOC WITH CACHING
// lib/feature/create_custom_habit/presentation/bloc/custom_habit_bloc.dart
// ============================================================================

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/activity_type.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/goal_value.dart';
import 'package:routiner/feature/create_custom_habit/domain/usecase/create_custom_habit_local_use_case.dart';
import 'package:routiner/feature/create_custom_habit/domain/usecase/create_custom_habit_remote_usecase.dart';
import 'package:routiner/core/constants/points_constants.dart';
import 'package:uuid/uuid.dart';

part 'custom_habit_event.dart';
part 'custom_habit_state.dart';

class CreateCustomHabitBloc
    extends Bloc<CreateCustomHabitEvent, CreateCustomHabitState> {
  CreateCustomHabitBloc({
    required final CreateCustomHabitLocalUsecase createCustomHabitLocalUsecase,
    required final CreateCustomHabitRemoteUsecase createCustomHabitRemoteUsecase,
  })  : _createCustomHabitLocalUsecase = createCustomHabitLocalUsecase,
        _createCustomHabitRemoteUsecase = createCustomHabitRemoteUsecase,
        super(const CreateCustomHabitState()) {
    on<NameChanged>(_onNameChanged);
    on<IconSelected>(_onIconSelected);
    on<HabitIconSelected>(_onHabitIconSelected);
    on<ColorSelected>(_onColorSelected);
    on<GoalValueChanged>(_onGoalValueChanged);
    on<ReminderAdded>(_onReminderAdded);
    on<ReminderRemoved>(_onReminderRemoved);
    on<TypeSelected>(_onTypeSelected);
    on<LocationChanged>(_onLocationChanged);
    on<SaveHabitPressed>(_onSaveHabitPressed);
    on<GoalFrequencyChanged>(_onGoalFrequencyChanged);
    on<GoalDaysChanged>(_onGoalDaysChanged);
    on<LoadActivities>(_onLoadActivities);
    on<LoadTotalPoints>(_onLoadTotalPoints);
  }

  final CreateCustomHabitLocalUsecase _createCustomHabitLocalUsecase;
  final CreateCustomHabitRemoteUsecase _createCustomHabitRemoteUsecase;

  // ============================================================================
  // CACHING MECHANISM
  // ============================================================================

  // Cache for habits list
  List<CustomHabitEntity>? _habitsCache;
  DateTime? _habitsCacheTime;
  static const Duration _habitsCacheDuration = Duration(minutes: 5);

  // Cache for activities
  List<ActivityEntity>? _activitiesCache;
  DateTime? _activitiesCacheTime;
  static const Duration _activitiesCacheDuration = Duration(minutes: 2);

  // Cache for total points
  int? _totalPointsCache;
  DateTime? _totalPointsCacheTime;
  static const Duration _pointsCacheDuration = Duration(minutes: 5);

  // ============================================================================
  // CACHE HELPER METHODS
  // ============================================================================

  bool _isHabitsCacheValid() {
    if (_habitsCache == null || _habitsCacheTime == null) return false;
    return DateTime.now().difference(_habitsCacheTime!) < _habitsCacheDuration;
  }

  bool _isActivitiesCacheValid() {
    if (_activitiesCache == null || _activitiesCacheTime == null) return false;
    return DateTime.now().difference(_activitiesCacheTime!) < _activitiesCacheDuration;
  }

  bool _isPointsCacheValid() {
    if (_totalPointsCache == null || _totalPointsCacheTime == null) return false;
    return DateTime.now().difference(_totalPointsCacheTime!) < _pointsCacheDuration;
  }

  void _invalidateHabitsCache() {
    _habitsCache = null;
    _habitsCacheTime = null;
  }

  void _invalidateActivitiesCache() {
    _activitiesCache = null;
    _activitiesCacheTime = null;
  }

  void _invalidatePointsCache() {
    _totalPointsCache = null;
    _totalPointsCacheTime = null;
  }

  void _invalidateAllCaches() {
    _invalidateHabitsCache();
    _invalidateActivitiesCache();
    _invalidatePointsCache();
  }

  // ============================================================================
  // EVENT HANDLERS - FORM STATE
  // ============================================================================

  void _onGoalDaysChanged(
      final GoalDaysChanged event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(state.copyWith(goalDays: event.days));
  }

  void _onNameChanged(
      final NameChanged event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(
      state.copyWith(
        name: event.name,
        isValid: event.name.trim().isNotEmpty,
      ),
    );
  }

  void _onIconSelected(
      final IconSelected event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(
      state.copyWith(
        selectedIcon: event.icon,
        clearHabit: true,
      ),
    );
  }

  void _onHabitIconSelected(
      final HabitIconSelected event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(
      state.copyWith(
        selectedHabit: event.habit,
        clearIcon: true,
      ),
    );
  }

  void _onColorSelected(
      final ColorSelected event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(state.copyWith(selectedColor: event.color));
  }

  void _onGoalValueChanged(
      final GoalValueChanged event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(
      state.copyWith(
        goalValue: event.goalValue.value,
        goalUnit: event.goalValue.unit,
      ),
    );
  }

  void _onReminderAdded(
      final ReminderAdded event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    final List<TimeOfDay> updatedReminders = List<TimeOfDay>.from(
      state.reminders,
    )..add(event.reminder);
    emit(state.copyWith(reminders: updatedReminders));
  }

  void _onReminderRemoved(
      final ReminderRemoved event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    final List<TimeOfDay> updatedReminders = List<TimeOfDay>.from(
      state.reminders,
    )..removeAt(event.index);
    emit(state.copyWith(reminders: updatedReminders));
  }

  void _onTypeSelected(
      final TypeSelected event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(state.copyWith(selectedType: event.type));
  }

  void _onLocationChanged(
      final LocationChanged event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(state.copyWith(location: event.location));
  }

  void _onGoalFrequencyChanged(
      final GoalFrequencyChanged event,
      final Emitter<CreateCustomHabitState> emit,
      ) {
    emit(state.copyWith(goalFrequency: event.frequency));
  }

  // ============================================================================
  // EVENT HANDLER - SAVE HABIT WITH POINTS (WITH CACHING)
  // ============================================================================

  Future<void> _onSaveHabitPressed(
      final SaveHabitPressed event,
      final Emitter<CreateCustomHabitState> emit,
      ) async {
    // Validation
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Please enter a habit name'));
      return;
    }

    if (state.selectedIcon == null && state.selectedHabit == null) {
      emit(state.copyWith(errorMessage: 'Please select an icon'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    // ============================================================================
    // STEP 1: Check for duplicate names (with caching)
    // ============================================================================

    List<CustomHabitEntity> existingHabits;

    if (_isHabitsCacheValid()) {
      // Use cached habits for fast validation
      existingHabits = _habitsCache!;
    } else {
      // Fetch from local storage (fast) and update cache
      existingHabits = await _createCustomHabitLocalUsecase.getCustomHabits();
      _habitsCache = existingHabits;
      _habitsCacheTime = DateTime.now();
    }

    final bool nameAlreadyExists = existingHabits.any(
          (final CustomHabitEntity h) =>
      h.name?.toLowerCase() == state.name.trim().toLowerCase(),
    );

    if (nameAlreadyExists) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Habit with this name already exists',
        ),
      );
      return;
    }

    // ============================================================================
    // STEP 2: Create habit entity
    // ============================================================================

    final CustomHabitEntity habit = CustomHabitEntity(
      id: const Uuid().v4(),
      name: state.name.trim(),
      icon: state.selectedIcon,
      habitIcon: state.selectedHabit,
      color: state.selectedColor,
      goal: state.goal,
      reminders: state.reminders,
      type: state.selectedType,
      location: state.location,
      createdAt: DateTime.now(),
      goalValue: state.goalValue,
      goalUnit: state.goalUnit,
      goalFrequency: state.goalFrequency,
      goalDays: state.goalDays,
      isAlarmEnabled: event.isAlarmEnabled,
      alarmTime: event.alarmTime ?? TimeOfDay.now(),
      alarmDays: event.alarmDays,
    );

    // ============================================================================
    // STEP 3: Create activity entity for points
    // ============================================================================

    final ActivityEntity activity = ActivityEntity(
      id: const Uuid().v4(),
      userId: '', // Will be populated by data source
      activityType: ActivityType.habitCreated,
      points: PointsConstants.habitCreated,
      description: 'Created habit: ${habit.name}',
      timestamp: DateTime.now(),
      relatedHabitId: habit.id,
      relatedHabitName: habit.name,
    );

    // ============================================================================
    // STEP 4: Save to LOCAL first (fast write - immediate feedback)
    // ============================================================================

    await _createCustomHabitLocalUsecase.createCustomHabit(habit);
    await _createCustomHabitLocalUsecase.saveActivity(activity);

    // Invalidate caches immediately after local write
    _invalidateHabitsCache();
    _invalidateActivitiesCache();
    _invalidatePointsCache();

    // Get updated total points from local cache
    final int localTotalPoints = await _createCustomHabitLocalUsecase.getTotalPoints();

    // ============================================================================
    // STEP 5: Update UI immediately with local data (fast feedback)
    // ============================================================================

    emit(
      state.copyWith(
        isLoading: false,
        isSaved: true,
        errorMessage: null,
        pointsEarned: PointsConstants.habitCreated,
        totalPoints: localTotalPoints,
      ),
    );

    // ============================================================================
    // STEP 6: Sync to REMOTE in background (eventual consistency)
    // ============================================================================

    // Save habit to remote
    final Either<Failure, String> remoteHabitResult =
    await _createCustomHabitRemoteUsecase(habit);

    remoteHabitResult.fold(
          (final Failure failure) {
        // Remote save failed - already saved locally, so no action needed
        // Can log or queue for retry later
      },
          (final String habitId) async {
        // Habit saved successfully, now save activity
        final Either<Failure, Unit> remoteActivityResult =
        await _createCustomHabitRemoteUsecase.saveActivity(activity);

        remoteActivityResult.fold(
              (final Failure failure) {
            // Activity save failed - already saved locally
          },
              (final Unit _) {
            // Successfully synced to remote
          },
        );
      },
    );
  }

  // ============================================================================
  // EVENT HANDLER - LOAD ACTIVITIES (WITH CACHING)
  // ============================================================================

  Future<void> _onLoadActivities(
      final LoadActivities event,
      final Emitter<CreateCustomHabitState> emit,
      ) async {
    // Check cache first
    if (_isActivitiesCacheValid() && !event.forceRefresh) {
      emit(
        state.copyWith(
          activities: _activitiesCache,
          isLoadingActivities: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingActivities: true));

    // Load from local storage (fast)
    final List<ActivityEntity> localActivities =
    await _createCustomHabitLocalUsecase.getActivities(
      limit: event.limit,
    );

    // Update cache
    _activitiesCache = localActivities;
    _activitiesCacheTime = DateTime.now();

    // Update UI with local data
    emit(
      state.copyWith(
        activities: localActivities,
        isLoadingActivities: false,
      ),
    );

    // Sync from remote in background
    if (event.syncFromRemote) {
      final Either<Failure, List<ActivityEntity>> remoteResult =
      await _createCustomHabitRemoteUsecase.getActivities(
        limit: event.limit,
      );

      remoteResult.fold(
            (final Failure failure) {
          // Remote fetch failed - already showing local data
        },
            (final List<ActivityEntity> remoteActivities) {
          // Update cache with remote data
          _activitiesCache = remoteActivities;
          _activitiesCacheTime = DateTime.now();

          // Update UI if different from local
          if (remoteActivities.length != localActivities.length) {
            emit(state.copyWith(activities: remoteActivities));
          }
        },
      );
    }
  }

  // ============================================================================
  // EVENT HANDLER - LOAD TOTAL POINTS (WITH CACHING)
  // ============================================================================

  Future<void> _onLoadTotalPoints(
      final LoadTotalPoints event,
      final Emitter<CreateCustomHabitState> emit,
      ) async {
    // Check cache first
    if (_isPointsCacheValid() && !event.forceRefresh) {
      emit(
        state.copyWith(
          totalPoints: _totalPointsCache,
          isLoadingPoints: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingPoints: true));

    // Load from local storage (fast)
    final int localPoints = await _createCustomHabitLocalUsecase.getTotalPoints();

    // Update cache
    _totalPointsCache = localPoints;
    _totalPointsCacheTime = DateTime.now();

    // Update UI with local data
    emit(
      state.copyWith(
        totalPoints: localPoints,
        isLoadingPoints: false,
      ),
    );

    // Sync from remote in background
    if (event.syncFromRemote) {
      final Either<Failure, int> remoteResult =
      await _createCustomHabitRemoteUsecase.getTotalPoints();

      remoteResult.fold(
            (final Failure failure) {
          // Remote fetch failed - already showing local data
        },
            (final int remotePoints) {
          // Update cache with remote data
          _totalPointsCache = remotePoints;
          _totalPointsCacheTime = DateTime.now();

          // Update UI if different from local
          if (remotePoints != localPoints) {
            emit(state.copyWith(totalPoints: remotePoints));
          }
        },
      );
    }
  }

  @override
  Future<void> close() {
    // Clear caches on bloc disposal
    _invalidateAllCaches();
    return super.close();
  }
}