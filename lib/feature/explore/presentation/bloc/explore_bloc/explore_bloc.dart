import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/explore/domain/usecase/explore_remote_usecase.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc({required this.exploreUseCase}) : super(ExploreInitial()) {
    on<LoadExploreDataEvent>(_onLoadExploreData);
    on<RequestToJoinClubFromExploreEvent>(_onRequestToJoinClub);
    on<RemoveMemberFromExploreEvent>(_onRemoveMember);
    on<LeaveClubFromExploreEvent>(_onLeaveClub);
  }

  final ExploreRemoteUseCase exploreUseCase;

  Future<void> _onLoadExploreData(
      final LoadExploreDataEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    emit(ExploreLoading());

    final Either<Failure, String> userIdResult =
    await exploreUseCase.getCurrentUserId();

    await userIdResult.fold(
          (final Failure failure) async {
        emit(ExploreLoaded(
          clubsError: failure.message,
        ));
      },
          (final String currentUserId) async {
        final clubsResult = await exploreUseCase.getAllClubs();
        final challengesResult = await exploreUseCase.getAllChallenges();

        List<ClubEntity>? clubs;
        String? clubsError;
        clubsResult.fold(
              (final Failure failure) {
            clubsError = failure.message;
          },
              (final List<ClubEntity> allClubs) {
            clubs = allClubs.take(5).toList();
          },
        );

        List<ChallengeEntity>? challenges;
        String? challengesError;
        challengesResult.fold(
              (final Failure failure) {
            challengesError = failure.message;
          },
              (final List<ChallengeEntity> allChallenges) {
            challenges = allChallenges.take(5).toList();
          },
        );

        emit(ExploreLoaded(
          clubs: clubs,
          currentUserId: currentUserId,
          challenges: challenges,
          clubsError: clubsError,
          challengesError: challengesError,
        ));
      },
    );
  }

  Future<void> _onRequestToJoinClub(
      final RequestToJoinClubFromExploreEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    final ExploreState currentState = state;

    if (currentState is! ExploreLoaded || currentState.clubs == null) {
      return;
    }

    emit(currentState.copyWith(actionLoadingClubId: event.clubId));

    final Either<Failure, Unit> result =
    await exploreUseCase.requestToJoinClub(event.clubId);

    result.fold(
          (final Failure failure) {
        emit(currentState.copyWith(
          clubsError: failure.message,
          actionLoadingClubId: null,
        ));
      },
          (_) {
        final List<ClubEntity> updatedClubs =
        currentState.clubs!.map((club) {
          if (club.id == event.clubId) {
            return club.copyWith(
              pendingRequestIds: [
                ...club.pendingRequestIds,
                currentState.currentUserId!,
              ],
            );
          }
          return club;
        }).toList();

        emit(
          currentState.copyWith(
            clubs: updatedClubs,
            actionLoadingClubId: null,
            successMessage: 'Join request sent',
          ),
        );
      },
    );
  }

  Future<void> _onRemoveMember(
      final RemoveMemberFromExploreEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    final Either<Failure, Unit> result =
    await exploreUseCase.removeMember(event.clubId, event.userId);

    result.fold(
          (final Failure failure) {
        if (state is ExploreLoaded) {
          emit((state as ExploreLoaded).copyWith(
            clubsError: failure.message,
          ));
        }
      },
          (_) {
        if (state is ExploreLoaded) {
          emit((state as ExploreLoaded).copyWith(
            successMessage: 'Member removed',
          ));
        }
        add(LoadExploreDataEvent());
      },
    );
  }

  Future<void> _onLeaveClub(
      final LeaveClubFromExploreEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    final Either<Failure, Unit> result =
    await exploreUseCase.leaveClub(event.clubId);

    result.fold(
          (final Failure failure) {
        if (state is ExploreLoaded) {
          emit((state as ExploreLoaded).copyWith(
            clubsError: failure.message,
          ));
        }
      },
          (_) {
        if (state is ExploreLoaded) {
          emit((state as ExploreLoaded).copyWith(
            successMessage: 'Left club successfully',
          ));
        }
        add(LoadExploreDataEvent());
      },
    );
  }
}