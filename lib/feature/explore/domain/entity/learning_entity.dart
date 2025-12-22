import 'package:equatable/equatable.dart';

class LearningItemEntity extends Equatable {

  const LearningItemEntity({
    required this.assetImage,
    required this.title,
  });
  final String assetImage;
  final String title;

  LearningItemEntity copyWith({
    final String? assetImage,
    final String? title,
  }) {
    return LearningItemEntity(
      assetImage: assetImage ?? this.assetImage,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [
    assetImage,
    title,
  ];
}
