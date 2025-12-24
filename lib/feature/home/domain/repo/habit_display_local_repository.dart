import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

abstract class HabitDisplayLocalRepository {
  Future<void> saveLog(final HabitLogEntity log);

  Future<List<HabitLogEntity>> getAllLogs();

  Future<void> updateLogsList(final List<HabitLogEntity> logs);

  Future<void> saveLogById(final String id, final HabitLogEntity log);

  Future<List<CustomHabitEntity>> getCustomHabits();

  Future<void> saveFriendsCount(final String habitId, final int count);

  Future<int?> getFriendsCount(final String habitId);

  Future<Map<String, int>> getAllFriendsCounts();

  Future<void> clearFriendsCount(final String habitId);
  Future<void> saveActivity(final ActivityEntity activity);
  Future<List<ActivityEntity>> getActivities({int? limit});
  Future<int> getTotalPoints();

}
