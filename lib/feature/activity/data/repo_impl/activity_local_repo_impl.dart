import 'package:routiner/feature/activity/data/data_source/local/activity_local_data_source.dart';
import 'package:routiner/feature/activity/domain/repo/activity_local_repo.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

class ActivityLocalRepositoryImpl implements ActivityLocalRepository {
  ActivityLocalRepositoryImpl(this._localDataSource);

  final ActivityLocalDataSource _localDataSource;

  @override
  List<MoodLogEntity> getMoodLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final models = _localDataSource.getMoodLogs(
      startDate: startDate,
      endDate: endDate,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  MoodLogEntity? getLatestMoodLog() {
    final model = _localDataSource.getLatestMoodLog();
    return model?.toEntity();
  }
}