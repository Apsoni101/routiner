import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_hive_model.dart';

abstract class MoodLocalDataSource {
  Future<void> saveMood(final String mood, final DateTime timestamp);

  Map<String, dynamic>? getMood();

  Future<void> clearMood();

  Future<void> saveMoodLog(final MoodLogHiveModel moodLog);

  List<MoodLogHiveModel> getAllMoodLogs();

  List<MoodLogHiveModel> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });

  Future<void> deleteMoodLog(final String logId);

  Future<void> clearAllMoodLogs();
}

class MoodLocalDataSourceImpl implements MoodLocalDataSource {
  MoodLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<void> saveMood(final String mood, final DateTime timestamp) async {
    await _hiveService.setString(HiveKeyConstants.moodKey, mood);
    await _hiveService.setString(
      HiveKeyConstants.moodTimestampKey,
      timestamp.toIso8601String(),
    );
  }

  @override
  Map<String, dynamic>? getMood() {
    final String? mood = _hiveService.getString(HiveKeyConstants.moodKey);
    final String? timestampStr = _hiveService.getString(
      HiveKeyConstants.moodTimestampKey,
    );

    if (mood == null) {
      return null;
    }

    DateTime? timestamp;
    if (timestampStr != null) {
      try {
        timestamp = DateTime.parse(timestampStr);
      } catch (e) {
        timestamp = null;
      }
    }

    return <String, dynamic>{'mood': mood, 'timestamp': timestamp};
  }

  @override
  Future<void> clearMood() async {
    await _hiveService.remove(HiveKeyConstants.moodKey);
    await _hiveService.remove(HiveKeyConstants.moodTimestampKey);
  }

  @override
  Future<void> saveMoodLog(final MoodLogHiveModel moodLog) async {
    final List<MoodLogHiveModel> moodLogs =
        _hiveService.getObjectList<MoodLogHiveModel>(
          HiveKeyConstants.moodLogsListKey,
        ) ??
        <MoodLogHiveModel>[];

    if (moodLog.id != null && moodLog.id!.isNotEmpty) {
      final int existingIndex = moodLogs.indexWhere(
        (final MoodLogHiveModel log) => log.id == moodLog.id,
      );

      if (existingIndex != -1) {
        moodLogs[existingIndex] = moodLog;
      } else {
        moodLogs.add(moodLog);
      }
    } else {
      final String generatedId = DateTime.now().millisecondsSinceEpoch
          .toString();
      final MoodLogHiveModel logWithId = moodLog.copyWith(id: generatedId);
      moodLogs.add(logWithId);
    }

    await _hiveService.setObjectList<MoodLogHiveModel>(
      HiveKeyConstants.moodLogsListKey,
      moodLogs,
    );
  }

  @override
  List<MoodLogHiveModel> getAllMoodLogs() {
    return _hiveService.getObjectList<MoodLogHiveModel>(
          HiveKeyConstants.moodLogsListKey,
        ) ??
        <MoodLogHiveModel>[];
  }

  @override
  List<MoodLogHiveModel> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    final List<MoodLogHiveModel> allLogs = getAllMoodLogs();

    return allLogs.where((final MoodLogHiveModel log) {
      final DateTime logDate = DateTime.parse(log.timestamp);
      return logDate.isAfter(startDate) && logDate.isBefore(endDate);
    }).toList();
  }

  @override
  Future<void> deleteMoodLog(final String logId) async {
    final List<MoodLogHiveModel> moodLogs = getAllMoodLogs()
      ..removeWhere((final MoodLogHiveModel log) => log.id == logId);

    await _hiveService.setObjectList<MoodLogHiveModel>(
      HiveKeyConstants.moodLogsListKey,
      moodLogs,
    );
  }

  @override
  Future<void> clearAllMoodLogs() async {
    await _hiveService.remove(HiveKeyConstants.moodLogsListKey);
  }
}
