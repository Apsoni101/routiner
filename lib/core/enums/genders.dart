import 'package:routiner/core/constants/asset_constants.dart';

enum Gender {
  male('Male', AppAssets.maleIc),
  female('Female', AppAssets.femaleIc);

  const Gender(this.label, this.path);

  final String label;
  final String path;
}
