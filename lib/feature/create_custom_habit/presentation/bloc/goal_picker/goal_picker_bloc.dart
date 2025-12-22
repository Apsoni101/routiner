import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/goal_unit.dart';

part 'goal_picker_event.dart';
part 'goal_picker_state.dart';

class GoalPickerBloc extends Bloc<GoalPickerEvent, GoalPickerState> {
  GoalPickerBloc({
    required GoalUnit initialUnit,
    required int initialValue,
  }) : super(
    GoalPickerReady(
      unit: initialUnit,
      value: initialValue,
      valueOptions: _buildValueOptions(initialUnit),
    ),
  ) {
    on<UnitChanged>(_onUnitChanged);
    on<ValueChanged>(_onValueChanged);
  }

  static List<int> _buildValueOptions(GoalUnit unit) {
    final list = <int>[];
    for (int i = unit.step; i <= unit.maxValue; i += unit.step) {
      list.add(i);
    }
    return list;
  }

  void _onUnitChanged(
      UnitChanged event,
      Emitter<GoalPickerState> emit,
      ) {
    emit(
      GoalPickerReady(
        unit: event.unit,
        value: event.unit.step,
        valueOptions: _buildValueOptions(event.unit),
      ),
    );
  }

  void _onValueChanged(
      ValueChanged event,
      Emitter<GoalPickerState> emit,
      ) {
    final current = state as GoalPickerReady;

    emit(
      GoalPickerReady(
        unit: current.unit,
        value: event.value,
        valueOptions: current.valueOptions,
      ),
    );
  }
}
