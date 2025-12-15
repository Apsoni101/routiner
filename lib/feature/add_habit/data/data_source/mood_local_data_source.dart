
import 'package:routiner/core/services/storage/hive_service.dart';

abstract class MoodLocalDataSource {
  Future<void> saveMood(final String mood);
  String? getMood();
  Future<void> clearMood();
}

class MoodLocalDataSourceImpl implements MoodLocalDataSource {
  MoodLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  static const String _moodKey = 'user_mood';

  @override
  Future<void> saveMood(final String mood) async {
    await _hiveService.setString(_moodKey, mood);
  }

  @override
  String? getMood() {
    return _hiveService.getString(_moodKey);
  }

  @override
  Future<void> clearMood() async {
    await _hiveService.remove(_moodKey);
  }
}
