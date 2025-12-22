import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/feature/explore/domain/entity/learning_entity.dart';

class AppConstants {
  static const int totalPages = 6;
  static const List<LearningItemEntity> learnings = [
    LearningItemEntity(
      assetImage: AppAssets.learningImgPng,
      title: 'Why should we drink water often?',
    ),
    LearningItemEntity(
      assetImage: AppAssets.learningImgPng2,
      title: 'Benefits of regular walking',
    ),
  ];
}
