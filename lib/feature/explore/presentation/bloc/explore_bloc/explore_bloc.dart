import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/explore/domain/usecase/explore_remote_usecase.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc({required this.exploreUseCase}) : super(ExploreInitial()) {
    on<LoadExploreClubsEvent>(_onLoadExploreClubs);
    on<RequestToJoinClubFromExploreEvent>(_onRequestToJoinClub);
    on<RemoveMemberFromExploreEvent>(_onRemoveMember);
    on<LeaveClubFromExploreEvent>(_onLeaveClub);
  }

  final ExploreRemoteUseCase exploreUseCase;

  Future<void> _onLoadExploreClubs(
      final LoadExploreClubsEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    emit(ExploreClubsLoading());

    // Get current user ID
    final Either<Failure, String> userIdResult = await exploreUseCase
        .getCurrentUserId();

    await userIdResult.fold(
          (final Failure failure) async {
        emit(ExploreClubsError(failure.message));
      },
          (final String currentUserId) async {
        // Fetch all clubs
        final Either<Failure, List<ClubEntity>> allClubsResult =
        await exploreUseCase.getAllClubs();

        allClubsResult.fold(
              (final Failure failure) {
            emit(ExploreClubsError(failure.message));
          },
              (final List<ClubEntity> allClubs) {
            // Limit to 5 clubs for explore screen
            final List<ClubEntity> limitedClubs = allClubs.take(5).toList();

            emit(
              ExploreClubsLoaded(
                clubs: limitedClubs,
                currentUserId: currentUserId,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRequestToJoinClub(
      final RequestToJoinClubFromExploreEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    final ExploreState currentState = state;

    if (currentState is! ExploreClubsLoaded) {
      return;
    }

    // Show loader on that club
    emit(currentState.copyWith(actionLoadingClubId: event.clubId));

    final Either<Failure, Unit> result = await exploreUseCase.requestToJoinClub(
      event.clubId,
    );

    result.fold(
          (final Failure failure) {
        emit(ExploreClubsError(failure.message));
      },
          (_) {
        // Update ONLY that club
        final List<ClubEntity> updatedClubs = currentState.clubs.map((
            final ClubEntity club,
            ) {
          if (club.id == event.clubId) {
            return club.copyWith(
              pendingRequestIds: <String>[
                ...club.pendingRequestIds,
                currentState.currentUserId,
              ],
            );
          }
          return club;
        }).toList();

        // ✅ Keep the state as ExploreClubsLoaded with success message
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
    final Either<Failure, Unit> result = await exploreUseCase.removeMember(
      event.clubId,
      event.userId,
    );

    result.fold(
          (final Failure failure) {
        emit(ExploreClubsError(failure.message));
      },
          (_) {
        // ✅ Keep current state if needed, then reload
        if (state is ExploreClubsLoaded) {
          emit((state as ExploreClubsLoaded).copyWith(
            successMessage: 'Member removed',
          ));
        }
        add(LoadExploreClubsEvent());
      },
    );
  }

  Future<void> _onLeaveClub(
      final LeaveClubFromExploreEvent event,
      final Emitter<ExploreState> emit,
      ) async {
    final Either<Failure, Unit> result = await exploreUseCase.leaveClub(
      event.clubId,
    );

    result.fold(
          (final Failure failure) {
        emit(ExploreClubsError(failure.message));
      },
          (_) {
        // ✅ Keep current state if needed, then reload
        if (state is ExploreClubsLoaded) {
          emit((state as ExploreClubsLoaded).copyWith(
            successMessage: 'Left club successfully',
          ));
        }
        add(LoadExploreClubsEvent());
      },
    );
  }
}