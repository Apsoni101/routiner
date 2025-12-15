

import 'package:routiner/feature/add_habit/data/data_source/mood_local_data_source.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository {
  MoodRepositoryImpl(this._localDataSource);

  final MoodLocalDataSource _localDataSource;

  @override
  Future<void> saveMood(final String mood) async {
    await _localDataSource.saveMood(mood);
  }

  @override
  String? getMood() {
    return _localDataSource.getMood();
  }

  @override
  Future<void> clearMood() async {
    await _localDataSource.clearMood();
  }
}
