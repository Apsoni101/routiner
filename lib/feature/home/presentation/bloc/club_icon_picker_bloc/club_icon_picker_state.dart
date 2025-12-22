
// club_icon_picker_state.dart
part of 'club_icon_picker_bloc.dart';

class ClubIconPickerState extends Equatable {
  const ClubIconPickerState({
    this.selectedIcon,
    this.selectedImageUrl,
    this.tabIndex = 0,
  });

  final IconData? selectedIcon;
  final String? selectedImageUrl;
  final int tabIndex;

  bool get canConfirm =>
      selectedIcon != null ||
          (selectedImageUrl != null && selectedImageUrl!.isNotEmpty);

  ClubIconPickerState copyWith({
    final IconData? selectedIcon,
    final String? selectedImageUrl,
    final int? tabIndex,
    final bool clearIcon = false,
    final bool clearImageUrl = false,
  }) {
    return ClubIconPickerState(
      selectedIcon: clearIcon ? null : (selectedIcon ?? this.selectedIcon),
      selectedImageUrl: clearImageUrl
          ? null
          : (selectedImageUrl ?? this.selectedImageUrl),
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedIcon, selectedImageUrl, tabIndex];
}