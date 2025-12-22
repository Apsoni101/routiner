part of 'create_club_bloc.dart';

@immutable
sealed class CreateClubEvent extends Equatable {
  const CreateClubEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends CreateClubEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class DescriptionChanged extends CreateClubEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class IconSelected extends CreateClubEvent {
  const IconSelected(this.icon);

  final IconData icon;

  @override
  List<Object?> get props => <Object?>[icon];
}
class ImageUrlChanged extends CreateClubEvent {
  const ImageUrlChanged(this.imageUrl);

  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

class FormSubmitted extends CreateClubEvent {
  const FormSubmitted();
}