import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/domain/usecase/club_usecase.dart';

part 'create_club_event.dart';
part 'create_club_state.dart';

class CreateClubBloc extends Bloc<CreateClubEvent, CreateClubState> {
  CreateClubBloc({required this.clubUseCase}) : super(const CreateClubState()) {
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<ImageUrlChanged>(_onImageUrlChanged);
    on<IconSelected>(_onIconSelected);
    on<FormSubmitted>(_onFormSubmitted);
  }

  final ClubRemoteUseCase clubUseCase;

  void _onNameChanged(
      final NameChanged event,
      final Emitter<CreateClubState> emit,
      ) {
    final String name = event.name.trim();
    final String? error = _validateName(name);

    emit(
      state.copyWith(
        name: name,
        nameError: error,
      ),
    );
  }

  void _onDescriptionChanged(
      final DescriptionChanged event,
      final Emitter<CreateClubState> emit,
      ) {
    final String description = event.description.trim();
    final String? error = _validateDescription(description);

    emit(
      state.copyWith(
        description: description,
        descriptionError: error,
      ),
    );
  }

  void _onImageUrlChanged(
      final ImageUrlChanged event,
      final Emitter<CreateClubState> emit,
      ) {
    emit(
      state.copyWith(
        imageUrl: event.imageUrl.trim(),
        selectedIcon: null,
        clearIcon: true,
      ),
    );
  }

  void _onIconSelected(
      final IconSelected event,
      final Emitter<CreateClubState> emit,
      ) {
    emit(
      state.copyWith(
        selectedIcon: event.icon,
        imageUrl: null,
        clearImageUrl: true,
      ),
    );
  }

  Future<void> _onFormSubmitted(
      final FormSubmitted event,
      final Emitter<CreateClubState> emit,
      ) async {
    // Validate all fields
    final String? nameError = _validateName(state.name);
    final String? descriptionError = _validateDescription(state.description);

    if (nameError != null || descriptionError != null) {
      emit(
        state.copyWith(
          nameError: nameError,
          descriptionError: descriptionError,
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateClubStatus.loading));

    // Convert icon to a string representation if selected
    String? finalImageUrl = state.imageUrl;
    if (state.selectedIcon != null && (state.imageUrl == null || state.imageUrl!.isEmpty)) {
      // Store icon codePoint as a special format
      finalImageUrl = 'icon:${state.selectedIcon!.codePoint}';
    }

    final Either<Failure, ClubEntity> result = await clubUseCase.createClub(
      name: state.name,
      description: state.description,
      imageUrl: finalImageUrl?.isEmpty ?? true ? null : finalImageUrl,
    );

    result.fold(
          (final Failure failure) {
        emit(
          state.copyWith(
            status: CreateClubStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
          (final ClubEntity club) {
        emit(
          state.copyWith(
            status: CreateClubStatus.success,
            createdClub: club,
          ),
        );
      },
    );
  }

  String? _validateName(final String name) {
    if (name.isEmpty) {
      return 'Please enter a club name';
    }
    return null;
  }

  String? _validateDescription(final String description) {
    if (description.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }
}