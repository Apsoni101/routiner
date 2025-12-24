// lib/feature/challenge/presentation/bloc/create_challenge_bloc/create_challenge_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/emojis.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_local_usecase.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_remote_usecase.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:uuid/uuid.dart';

part 'create_challenge_event.dart';

part 'create_challenge_state.dart';

class CreateChallengeBloc
    extends Bloc<CreateChallengeEvent, CreateChallengeState> {
  CreateChallengeBloc({
    required final ChallengeRemoteUsecase remoteUsecase,
    required final ChallengeLocalUsecase localUsecase,
  }) : _remoteUsecase = remoteUsecase,
       _localUsecase = localUsecase,
       super(const CreateChallengeInitial()) {
    on<LoadUserHabits>(_onLoadUserHabits);
    on<UpdateTitle>(_onUpdateTitle);
    on<UpdateDescription>(_onUpdateDescription);
    on<UpdateEmoji>(_onUpdateEmoji);
    on<UpdateDuration>(_onUpdateDuration);
    on<UpdateDurationType>(_onUpdateDurationType);
    on<UpdateSelectedHabits>(_onUpdateSelectedHabits);
    on<CreateChallengePressed>(_onCreateChallengePressed);
  }

  final ChallengeRemoteUsecase _remoteUsecase;
  final ChallengeLocalUsecase _localUsecase;
  final Uuid _uuid = const Uuid();

  Future<void> _onLoadUserHabits(
    final LoadUserHabits event,
    final Emitter<CreateChallengeState> emit,
  ) async {
    emit(state.copyWith(isLoadingHabits: true));

    // 1. Load from local storage first (instant display)
    final List<CustomHabitEntity> localHabits = await _localUsecase
        .getAllHabits();

    if (localHabits.isNotEmpty) {
      emit(
        state.copyWith(isLoadingHabits: false, availableHabits: localHabits),
      );
    }

    // 2. Fetch from remote (background sync)
    final Either<Failure, List<CustomHabitEntity>> result = await _remoteUsecase
        .getUserHabits();

    result.fold(
      (final Failure failure) {
        // Keep local data on error
        if (localHabits.isEmpty) {
          emit(
            state.copyWith(
              isLoadingHabits: false,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (final List<CustomHabitEntity> remoteHabits) {
        emit(
          state.copyWith(isLoadingHabits: false, availableHabits: remoteHabits),
        );
      },
    );
  }

  void _onUpdateTitle(
    final UpdateTitle event,
    final Emitter<CreateChallengeState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateDescription(
    final UpdateDescription event,
    final Emitter<CreateChallengeState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onUpdateEmoji(
    final UpdateEmoji event,
    final Emitter<CreateChallengeState> emit,
  ) {
    emit(state.copyWith(emoji: event.emoji));
  }

  void _onUpdateDuration(
    final UpdateDuration event,
    final Emitter<CreateChallengeState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  void _onUpdateDurationType(
    final UpdateDurationType event,
    final Emitter<CreateChallengeState> emit,
  ) {
    emit(state.copyWith(durationType: event.durationType));
  }

  void _onUpdateSelectedHabits(
    final UpdateSelectedHabits event,
    final Emitter<CreateChallengeState> emit,
  ) {
    emit(state.copyWith(selectedHabits: event.habits));
  }

  Future<void> _onCreateChallengePressed(
    final CreateChallengePressed event,
    final Emitter<CreateChallengeState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Please fill all required fields'));
      return;
    }

    emit(state.copyWith(isCreating: true));

    // Get user ID through the use case
    final Either<Failure, String> userIdResult = await _remoteUsecase
        .getCurrentUserId();

    await userIdResult.fold(
      (final Failure failure) async {
        emit(state.copyWith(isCreating: false, errorMessage: failure.message));
      },
      (final String userId) async {
        final DateTime now = DateTime.now();
        DateTime? endDate;

        switch (state.durationType) {
          case ChallengeDurationType.hours:
            endDate = now.add(Duration(hours: state.duration));
            break;
          case ChallengeDurationType.days:
            endDate = now.add(Duration(days: state.duration));
            break;
          case ChallengeDurationType.weeks:
            endDate = now.add(Duration(days: state.duration * 7));
            break;
          case ChallengeDurationType.months:
            endDate = now.add(Duration(days: state.duration * 30));
            break;
        }

        final String challengeId = _uuid.v4();

        final ChallengeEntity challenge = ChallengeEntity(
          id: challengeId,
          title: state.title,
          description: state.description,
          emoji: state.emoji,
          duration: state.duration,
          durationType: state.durationType,
          habitIds: state.selectedHabits
              .map((final CustomHabitEntity h) => h.id!)
              .toList(),
          creatorId: userId,
          participantIds: <String>[userId],
          createdAt: now,
          startDate: now,
          endDate: endDate,
          isActive: true,
          totalGoalValue: 0,
          completedValue: 0,
        );

        // 1. Save to local storage first (optimistic update)
        await _localUsecase.saveChallenge(challenge);

        // Update local challenges list
        final List<ChallengeEntity> localChallenges = await _localUsecase
            .getAllChallenges();
        localChallenges.add(challenge);
        await _localUsecase.updateChallengesList(localChallenges);

        // Save participant IDs cache
        await _localUsecase.saveParticipantIds(
          challengeId: challengeId,
          participantIds: <String>[userId],
        );

        // 2. Emit success state immediately
        emit(
          state.copyWith(
            isCreating: false,
            isSuccess: true,
            createdChallengeId: challengeId,
          ),
        );

        // 3. Sync to remote in background
        final Either<Failure, String> result = await _remoteUsecase
            .createChallenge(challenge);

        result.fold((final _) {}, (final String returnedId) {
          _localUsecase.saveLastSyncTime(DateTime.now());
        });
      },
    );
  }
}
