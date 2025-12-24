import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_hive_model.dart';

abstract class ActivityLocalDataSource {
  // Mood-related methods
  List<MoodLogHiveModel> getMoodLogs({
    required DateTime startDate,
    required DateTime endDate,
  });

  MoodLogHiveModel? getLatestMoodLog();
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  ActivityLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  List<MoodLogHiveModel> getMoodLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final List<MoodLogHiveModel> allLogs =
        _hiveService.getObjectList<MoodLogHiveModel>(
          HiveKeyConstants.moodLogsListKey,
        ) ??
            <MoodLogHiveModel>[];

    return allLogs.where((log) {
      final DateTime logDate = DateTime.parse(log.timestamp);
      return logDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          logDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  MoodLogHiveModel? getLatestMoodLog() {
    final List<MoodLogHiveModel> allLogs =
        _hiveService.getObjectList<MoodLogHiveModel>(
          HiveKeyConstants.moodLogsListKey,
        ) ??
            <MoodLogHiveModel>[];

    if (allLogs.isEmpty) return null;

    allLogs.sort((a, b) =>
        DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

    return allLogs.first;
  }
}