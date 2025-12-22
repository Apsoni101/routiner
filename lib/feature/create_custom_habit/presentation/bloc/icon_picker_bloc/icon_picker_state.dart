part of 'icon_picker_bloc.dart';

class IconPickerState extends Equatable {
  const IconPickerState({
    this.selectedIcon,
    this.selectedHabit,
    this.tabIndex = 0,
  });

  final IconData? selectedIcon;
  final Habit? selectedHabit;
  final int tabIndex;

  bool get canConfirm => selectedIcon != null || selectedHabit != null;

  IconPickerState copyWith({
    final IconData? selectedIcon,
    final Habit? selectedHabit,
    final int? tabIndex,
    final bool clearIcon = false,
    final bool clearHabit = false,
  }) {
    return IconPickerState(
      selectedIcon: clearIcon ? null : (selectedIcon ?? this.selectedIcon),
      selectedHabit: clearHabit ? null : (selectedHabit ?? this.selectedHabit),
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => [selectedIcon, selectedHabit, tabIndex];
}