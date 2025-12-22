import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/domain/usecase/club_usecase.dart';

part 'club_list_event.dart';

part 'club_list_state.dart';

class ClubListBloc extends Bloc<ClubListEvent, ClubListState> {
  ClubListBloc({required this.clubUseCase}) : super(ClubInitial()) {
    on<LoadClubsEvent>(_onLoadClubs);
    on<LoadCurrentUserIdEvent>(_onLoadCurrentUserId);
    on<CreateClubEvent>(_onCreateClub);
    on<RequestToJoinClubEvent>(_onRequestToJoinClub);
    on<AcceptJoinRequestEvent>(_onAcceptJoinRequest);
    on<RejectJoinRequestEvent>(_onRejectJoinRequest);
    on<RemoveMemberEvent>(_onRemoveMember);
    on<LeaveClubEvent>(_onLeaveClub);
  }

  final ClubRemoteUseCase clubUseCase;

  Future<void> _onLoadClubs(
    final LoadClubsEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    emit(ClubLoading());

    // First get current user ID
    final Either<Failure, String> userIdResult = await clubUseCase
        .getCurrentUserId();

    await userIdResult.fold(
      (final Failure failure) async {
        emit(ClubError(failure.message));
      },
      (final String currentUserId) async {
        // Fetch all clubs
        final Either<Failure, List<ClubEntity>> allClubsResult =
            await clubUseCase.getAllClubs();

        await allClubsResult.fold(
          (final Failure failure) async {
            emit(ClubError(failure.message));
          },
          (final List<ClubEntity> allClubs) async {
            // Fetch user clubs
            final Either<Failure, List<ClubEntity>> userClubsResult =
                await clubUseCase.getUserClubs();

            userClubsResult.fold(
              (final Failure failure) {
                emit(ClubError(failure.message));
              },
              (final List<ClubEntity> userClubs) {
                emit(
                  ClubsLoaded(
                    allClubs: allClubs,
                    userClubs: userClubs,
                    currentUserId: currentUserId,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onLoadCurrentUserId(
    final LoadCurrentUserIdEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    final Either<Failure, String> result = await clubUseCase.getCurrentUserId();

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (final String userId) {
        if (state is ClubsLoaded) {
          final ClubsLoaded currentState = state as ClubsLoaded;
          emit(
            ClubsLoaded(
              allClubs: currentState.allClubs,
              userClubs: currentState.userClubs,
              currentUserId: userId,
            ),
          );
        }
      },
    );
  }

  Future<void> _onCreateClub(
    final CreateClubEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    emit(ClubLoading());

    final Either<Failure, ClubEntity> result = await clubUseCase.createClub(
      name: event.name,
      description: event.description,
      imageUrl: event.imageUrl,
    );

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (final ClubEntity club) {
        emit(ClubCreated(club));
        // Reload clubs after creation
        add(LoadClubsEvent());
      },
    );
  }

  Future<void> _onRequestToJoinClub(
    final RequestToJoinClubEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubUseCase.requestToJoinClub(
      event.clubId,
    );

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (_) {
        emit(const ClubActionSuccess('Join request sent'));
        // Reload clubs to update UI
        add(LoadClubsEvent());
      },
    );
  }

  Future<void> _onAcceptJoinRequest(
    final AcceptJoinRequestEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubUseCase.acceptJoinRequest(
      event.clubId,
      event.userId,
    );

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (_) {
        emit(const ClubActionSuccess('Request accepted'));
        add(LoadClubsEvent());
      },
    );
  }

  Future<void> _onRejectJoinRequest(
    final RejectJoinRequestEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubUseCase.rejectJoinRequest(
      event.clubId,
      event.userId,
    );

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (_) {
        emit(const ClubActionSuccess('Request rejected'));
        add(LoadClubsEvent());
      },
    );
  }

  Future<void> _onRemoveMember(
    final RemoveMemberEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubUseCase.removeMember(
      event.clubId,
      event.userId,
    );

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (_) {
        emit(const ClubActionSuccess('Member removed'));
        add(LoadClubsEvent());
      },
    );
  }

  Future<void> _onLeaveClub(
    final LeaveClubEvent event,
    final Emitter<ClubListState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubUseCase.leaveClub(
      event.clubId,
    );

    result.fold(
      (final Failure failure) {
        emit(ClubError(failure.message));
      },
      (_) {
        emit(const ClubActionSuccess('Left club successfully'));
        add(LoadClubsEvent());
      },
    );
  }
}
