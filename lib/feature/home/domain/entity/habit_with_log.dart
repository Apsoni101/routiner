import 'package:equatable/equatable.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class HabitWithLog extends Equatable {
  const HabitWithLog({
    required this.habit,
    required this.log,
  });

  final CustomHabitEntity habit;
  final HabitLogEntity log;

  @override
  List<Object> get props => <Object>[habit, log];
}
