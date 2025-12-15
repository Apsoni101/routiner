import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/moods.dart';
import 'package:routiner/feature/add_habit/domain/usecase/mood_usecase.dart';

part 'mood_event.dart';

part 'mood_state.dart';
class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc({required final MoodUsecase moodUsecase})
      : _moodUsecase = moodUsecase,
        super(const MoodInitial()) {
    on<MoodLoaded>(_onMoodLoaded);
    on<MoodSelected>(_onMoodSelected);
    on<MoodCleared>(_onMoodCleared);

    // Load initial mood when bloc is created
    add(const MoodLoaded());
  }

  final MoodUsecase _moodUsecase;

  void _onMoodLoaded(MoodLoaded event, Emitter<MoodState> emit) {
    emit(const MoodLoading());

    final String? savedMoodString = _moodUsecase.getMood();
    final Mood? savedMood = Mood.fromString(savedMoodString);

    emit(MoodLoadSuccess(savedMood));
  }

  Future<void> _onMoodSelected(
      MoodSelected event,
      Emitter<MoodState> emit,
      ) async {
    await _moodUsecase.saveMood(event.mood.label);
    emit(MoodLoadSuccess(event.mood)); // Changed to MoodLoadSuccess
  }

  Future<void> _onMoodCleared(
      final MoodCleared event,
      final Emitter<MoodState> emit,
      ) async {
    await _moodUsecase.clearMood();
    emit(const MoodLoadSuccess(null));
  }
}
