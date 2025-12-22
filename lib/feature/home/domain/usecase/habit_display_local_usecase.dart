import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/repo/habit_display_local_repository.dart';

class HabitDisplayLocalUsecase {
  HabitDisplayLocalUsecase(this._repository);

  final HabitDisplayLocalRepository _repository;

  Future<void> saveLog(final HabitLogEntity log) {
    return _repository.saveLog(log);
  }

  Future<List<HabitLogEntity>> getAllLogs() {
    return _repository.getAllLogs();
  }

  Future<void> updateLogsList(final List<HabitLogEntity> logs) {
    return _repository.updateLogsList(logs);
  }

  Future<void> saveLogById(final String id, final HabitLogEntity log) {
    return _repository.saveLogById(id, log);
  }

  Future<List<CustomHabitEntity>> getCustomHabits() {
    return _repository.getCustomHabits();
  }
  Future<void> saveFriendsCount(final String habitId, final int count) {
    return _repository.saveFriendsCount(habitId, count);
  }

  Future<int?> getFriendsCount(final String habitId) {
    return _repository.getFriendsCount(habitId);
  }

  Future<Map<String, int>> getAllFriendsCounts() {
    return _repository.getAllFriendsCounts();
  }

  Future<void> clearFriendsCount(final String habitId) {
    return _repository.clearFriendsCount(habitId);
  }
}
