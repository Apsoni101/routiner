import 'package:flutter/material.dart';
import 'package:routiner/core/constants/asset_constants.dart';

enum ActivityType {
  habitCreated(path: AppAssets.greenArrowUpIc),
  habitCompleted(path: AppAssets.greenArrowUpIc),
  streakAchieved(path: AppAssets.challengeIc),
  goalReached(path: AppAssets.challengeIc);

  const ActivityType({required this.path});

  final String path;
}
