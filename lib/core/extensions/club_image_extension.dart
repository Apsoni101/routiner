import 'package:flutter/material.dart';
import 'package:routiner/core/constants/asset_constants.dart';
extension ClubImageExtension on String? {
  bool get isIcon =>
      this != null && this!.startsWith('icon:');

  bool get isNetwork =>
      this != null &&
          (this!.startsWith('http://') ||
              this!.startsWith('https://'));

  bool get isAsset =>
      this != null &&
          !isIcon &&
          !isNetwork &&
          this!.contains('/');

  IconData? get toIconData {
    if (!isIcon) return null;
    final code = int.tryParse(this!.split(':').last);
    if (code == null) return null;
    return IconData(code, fontFamily: 'MaterialIcons');
  }

  /// Always returns something valid
  String get safeImage =>
      this ?? AppAssets.appLogoIc;
}
