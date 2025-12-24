
// lib/feature/add_habit/presentation/bloc/mood_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/moods.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_hive_model.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';
import 'package:routiner/feature/add_habit/domain/usecase/mood_local_usecase.dart';
import 'package:routiner/feature/add_habit/domain/usecase/mood_remote_usecase.dart';

part 'mood_event.dart';
part 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc({
    required final MoodLocalUsecase moodLocalUsecase,
    required final MoodRemoteUsecase moodRemoteUsecase,
  })  : _moodLocalUsecase = moodLocalUsecase,
        _moodRemoteUsecase = moodRemoteUsecase,
        super(const MoodInitial()) {
    on<MoodLoaded>(_onMoodLoaded);
    on<MoodSelected>(_onMoodSelected);
    on<MoodCleared>(_onMoodCleared);
    on<MoodSyncRequested>(_onMoodSyncRequested);

    // Load initial mood when bloc is created
    add(const MoodLoaded());
  }

  final MoodLocalUsecase _moodLocalUsecase;
  final MoodRemoteUsecase _moodRemoteUsecase;

  void _onMoodLoaded(MoodLoaded event, Emitter<MoodState> emit) {
    emit(const MoodLoading());

    // Get local mood with timestamp for instant feedback
    final Map<String, dynamic>? moodData = _moodLocalUsecase.getMood();

    Mood? savedMood;
    DateTime? timestamp;

    if (moodData != null) {
      savedMood = Mood.fromString(moodData['mood'] as String?);
      timestamp = moodData['timestamp'] as DateTime?;
    }

    emit(MoodLoadSuccess(savedMood, timestamp: timestamp));

    // Optionally sync with remote in background
    add(const MoodSyncRequested());
  }

  Future<void> _onMoodSelected(
      MoodSelected event,
      Emitter<MoodState> emit,
      ) async {
    final DateTime timestamp = DateTime.now();

    // 1. Save to current state for instant UI feedback (optimistic update)
    await _moodLocalUsecase.saveMood(event.mood.label, timestamp);
    emit(MoodLoadSuccess(event.mood, timestamp: timestamp));

    // 2. Save to local Hive box (mood history)
    final MoodLogHiveModel localMoodLog = MoodLogHiveModel(
      mood: event.mood.label,
      timestamp: timestamp.toIso8601String(),
    );
    await _moodLocalUsecase.saveMoodLog(localMoodLog);

    // 3. Save to remote Firestore (cloud backup)
    final MoodLogEntity remoteMoodLog = MoodLogEntity(
      mood: event.mood.label,
      timestamp: timestamp,
    );

    final result = await _moodRemoteUsecase.saveMoodLog(remoteMoodLog);

    result.fold(
          (failure) {
        // If remote save fails, still keep local state but show error
        emit(MoodError(
          failure.message,
          selectedMood: event.mood,
          timestamp: timestamp,
        ));

        // Restore success state after showing error
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            add(const MoodLoaded());
          }
        });
      },
          (logId) {
        // Successfully saved remotely - update local log with remote ID
        final MoodLogHiveModel updatedLog = localMoodLog.copyWith(id: logId);
        _moodLocalUsecase.saveMoodLog(updatedLog);

        emit(MoodLoadSuccess(event.mood, timestamp: timestamp));
      },
    );
  }

  Future<void> _onMoodCleared(
      final MoodCleared event,
      final Emitter<MoodState> emit,
      ) async {
    // Only clear current mood state, keep history
    await _moodLocalUsecase.clearMood();
    emit(const MoodLoadSuccess(null));
  }

  Future<void> _onMoodSyncRequested(
      final MoodSyncRequested event,
      final Emitter<MoodState> emit,
      ) async {
    // Get the latest mood from remote
    final result = await _moodRemoteUsecase.getLatestMood();

    result.fold(
          (failure) {
        // Sync failed, keep current state
        // Could log this or show a subtle indicator
      },
          (remoteMoodLog) {
        if (remoteMoodLog != null) {
          final Mood? remoteMood = Mood.fromString(remoteMoodLog.mood);
          if (remoteMood != null) {
            // Check if remote mood is newer than local
            final Map<String, dynamic>? localMoodData =
            _moodLocalUsecase.getMood();
            final DateTime? localTimestamp =
            localMoodData?['timestamp'] as DateTime?;

            // Only update if remote is newer or local doesn't exist
            if (localTimestamp == null ||
                remoteMoodLog.timestamp.isAfter(localTimestamp)) {

              // Update local current state
              _moodLocalUsecase.saveMood(
                remoteMood.label,
                remoteMoodLog.timestamp,
              );

              // Also save to local history
              final MoodLogHiveModel localLog = MoodLogHiveModel(
                id: remoteMoodLog.id,
                mood: remoteMoodLog.mood,
                timestamp: remoteMoodLog.timestamp.toIso8601String(),
              );
              _moodLocalUsecase.saveMoodLog(localLog);

              // Update UI
              emit(MoodLoadSuccess(
                remoteMood,
                timestamp: remoteMoodLog.timestamp,
              ));
            }
          }
        }
      },
    );
  }
}