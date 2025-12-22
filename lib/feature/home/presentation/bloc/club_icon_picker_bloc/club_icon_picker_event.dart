
// club_icon_picker_event.dart
part of 'club_icon_picker_bloc.dart';

abstract class ClubIconPickerEvent extends Equatable {
  const ClubIconPickerEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class IconSelected extends ClubIconPickerEvent {
  const IconSelected(this.icon);

  final IconData icon;

  @override
  List<Object?> get props => <Object?>[icon];
}

class ImageUrlChanged extends ClubIconPickerEvent {
  const ImageUrlChanged(this.imageUrl);

  final String imageUrl;

  @override
  List<Object?> get props => <Object?>[imageUrl];
}

class TabChanged extends ClubIconPickerEvent {
  const TabChanged(this.index);

  final int index;

  @override
  List<Object?> get props => <Object?>[index];
}
