import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/usecase/habit_display_local_usecase.dart';
import 'package:uuid/uuid.dart';

part 'update_value_dialog_event.dart';
part 'update_value_dialog_state.dart';
class UpdateValueDialogBloc extends Bloc<UpdateValueDialogEvent, UpdateValueDialogState> {
  UpdateValueDialogBloc({
    required this.habitDisplayUsecase,
  }) : super(const UpdateValueDialogInitial()) {
    on<InitializeDialog>(_onInitializeDialog);
    on<ValueChanged>(_onValueChanged);
    on<SubmitValue>(_onSubmitValue);
    on<ResetDialog>(_onResetDialog);
  }

  final HabitDisplayLocalUsecase habitDisplayUsecase;
  final Uuid _uuid = const Uuid();

  // Store dialog context data
  HabitLogEntity? _log;
  int? _maxValue;

  void _onInitializeDialog(
      InitializeDialog event,
      Emitter<UpdateValueDialogState> emit,
      ) {
    _log = event.log;
    _maxValue = event.maxValue;

    emit(UpdateValueDialogEditing(
      value: event.currentValue.toString(),
      errorMessage: null,
    ));
  }

  void _onValueChanged(
      ValueChanged event,
      Emitter<UpdateValueDialogState> emit,
      ) {
    if (_maxValue == null) return;

    final String value = event.value;
    String? errorMessage;

    if (value.isNotEmpty) {
      final int? parsedValue = int.tryParse(value);

      if (parsedValue == null) {
        errorMessage = 'Please enter a valid number';
      } else if (parsedValue < 0) {
        errorMessage = 'Value cannot be negative';
      } else if (parsedValue > _maxValue!) {
        errorMessage = 'Value cannot exceed $_maxValue';
      }
    }

    emit(UpdateValueDialogEditing(
      value: value,
      errorMessage: errorMessage,
    ));
  }

  Future<void> _onSubmitValue(
      SubmitValue event,
      Emitter<UpdateValueDialogState> emit,
      ) async {
    if (state is! UpdateValueDialogEditing || _log == null || _maxValue == null) {
      return;
    }

    final currentState = state as UpdateValueDialogEditing;

    if (currentState.errorMessage != null || currentState.value.isEmpty) {
      return;
    }

    final int? parsedValue = int.tryParse(currentState.value);
    if (parsedValue == null) {
      return;
    }

    emit(const UpdateValueDialogSubmitting());

    try {
      // Generate or use existing log ID
      final String logId = (_log!.id == null || _log!.id!.isEmpty)
          ? _uuid.v4()
          : _log!.id!;

      // Determine status based on value
      final LogStatus status = parsedValue >= _maxValue!
          ? LogStatus.completed
          : LogStatus.pending;

      // Create updated log
      final HabitLogEntity updatedLog = _log!.copyWith(
        id: logId,
        status: status,
        completedValue: parsedValue,
        completedAt: status == LogStatus.completed ? DateTime.now() : null,
      );

      // Get all logs and update
      final List<HabitLogEntity> allLogs = await habitDisplayUsecase.getAllLogs();

      final int index = allLogs.indexWhere(
            (final HabitLogEntity existingLog) => existingLog.id == logId,
      );

      if (index != -1) {
        allLogs[index] = updatedLog;
      } else {
        allLogs.add(updatedLog);
      }

      // Save updated logs
      await habitDisplayUsecase.updateLogsList(allLogs);
      await habitDisplayUsecase.saveLogById(logId, updatedLog);

      emit(const UpdateValueDialogSuccess());
    } catch (e) {
      emit(UpdateValueDialogError('Failed to update habit: ${e.toString()}'));
    }
  }

  void _onResetDialog(
      ResetDialog event,
      Emitter<UpdateValueDialogState> emit,
      ) {
    _log = null;
    _maxValue = null;
    emit(const UpdateValueDialogInitial());
  }
}