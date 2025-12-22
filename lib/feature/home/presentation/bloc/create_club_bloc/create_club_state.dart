part of 'create_club_bloc.dart';

enum CreateClubStatus { initial, loading, success, error }

class CreateClubState extends Equatable {
  const CreateClubState({
    this.name = '',
    this.description = '',
    this.imageUrl,
    this.selectedIcon,
    this.nameError,
    this.descriptionError,
    this.status = CreateClubStatus.initial,
    this.errorMessage,
    this.createdClub,
  });

  final String name;
  final String description;
  final String? imageUrl;
  final IconData? selectedIcon;
  final String? nameError;
  final String? descriptionError;
  final CreateClubStatus status;
  final String? errorMessage;
  final ClubEntity? createdClub;

  bool get hasIcon => selectedIcon != null || (imageUrl != null && imageUrl!.isNotEmpty);

  CreateClubState copyWith({
    final String? name,
    final String? description,
    final String? imageUrl,
    final IconData? selectedIcon,
    final String? nameError,
    final String? descriptionError,
    final CreateClubStatus? status,
    final String? errorMessage,
    final ClubEntity? createdClub,
    final bool clearIcon = false,
    final bool clearImageUrl = false,
  }) {
    return CreateClubState(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      selectedIcon: clearIcon ? null : (selectedIcon ?? this.selectedIcon),
      nameError: nameError ?? this.nameError,
      descriptionError: descriptionError ?? this.descriptionError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdClub: createdClub ?? this.createdClub,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    name,
    description,
    imageUrl,
    selectedIcon,
    nameError,
    descriptionError,
    status,
    errorMessage,
    createdClub,
  ];
}