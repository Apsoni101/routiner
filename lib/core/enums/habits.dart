import 'package:routiner/core/constants/asset_constants.dart';

enum Habit {
  sleep('Sleep', AppAssets.sleepIc),
  waterPlant('Water Plant', AppAssets.waterPlantIc),
  journal('Journal', AppAssets.journalIc),
  study('Study', AppAssets.studyIc),
  meditate('Meditate', AppAssets.meditateIc),
  book('Book', AppAssets.bookIc),
  run('Run', AppAssets.runIc),
  water('Drink Water', AppAssets.waterIc);

  const Habit(this.label, this.path);

  final String label;
  final String path;
}
