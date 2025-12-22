import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/habits_list/data/data_source/local_data_source/habits_list_local_data_source.dart';
import 'package:routiner/feature/habits_list/domain/repo/habits_list_repository.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class HabitsListLocalRepositoryImpl implements HabitsListLocalRepository {
  HabitsListLocalRepositoryImpl(this._localDataSource);

  final HabitsListLocalDataSource _localDataSource;

  @override
  Future<void> saveLog(final HabitLogEntity log) {
    final HabitLogHiveModel model = HabitLogHiveModel.fromEntity(log);
    return _localDataSource.saveLog(model);
  }

  @override
  Future<List<HabitLogEntity>> getAllLogs() async {
    final List<HabitLogHiveModel> models = await _localDataSource.getAllLogs();
    return models.map((final HabitLogHiveModel m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateLogsList(final List<HabitLogEntity> logs) {
    final List<HabitLogHiveModel> models = logs
        .map(HabitLogHiveModel.fromEntity)
        .toList();
    return _localDataSource.updateLogsList(models);
  }

  @override
  Future<void> saveLogById(final String id, final HabitLogEntity log) {
    final HabitLogHiveModel model = HabitLogHiveModel.fromEntity(log);
    return _localDataSource.saveLogById(id, model);
  }

  @override
  Future<List<CustomHabitEntity>> getCustomHabits() async {
    final List<CustomHabitHiveModel> models = await _localDataSource
        .getCustomHabits();
    return models.map((final CustomHabitHiveModel m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveFriendsCount(final String habitId, final int count) {
    return _localDataSource.saveFriendsCount(habitId, count);
  }

  @override
  Future<int?> getFriendsCount(final String habitId) {
    return _localDataSource.getFriendsCount(habitId);
  }

  @override
  Future<Map<String, int>> getAllFriendsCounts() {
    return _localDataSource.getAllFriendsCounts();
  }

  @override
  Future<void> clearFriendsCount(final String habitId) {
    return _localDataSource.clearFriendsCount(habitId);
  }
}
