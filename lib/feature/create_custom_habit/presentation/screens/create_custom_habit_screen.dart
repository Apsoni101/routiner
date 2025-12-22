import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:routiner/core/controller/toggle_switch_controller.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/services/utils/alarm_service.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/create_custom_habit_text.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_button.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/goal_value.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/alarm_dialog/alarm_dialog_bloc.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/alarm_dialog/alarm_dialog_event.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/alarm_dialog/alarm_dialog_state.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/custom_habit_bloc.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/color_picker_dialog.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/custom_toggle.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/goal_card.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/icon_color_row.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/icon_picker_dialog.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/reminder_card.dart';
import 'package:routiner/feature/profile/presentation/widgets/profile_textfield.dart';

@RoutePage()
class CreateCustomHabitScreen extends StatelessWidget {
  const CreateCustomHabitScreen({super.key, this.selectedHabit});

  final Habit? selectedHabit;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CreateCustomHabitBloc>(
          create: (final BuildContext context) =>
              AppInjector.getIt<CreateCustomHabitBloc>(),
        ),
        BlocProvider<AlarmBloc>(
          create: (final BuildContext context) => AlarmBloc(AlarmService()),
        ),
      ],
      child: _CreateCustomHabitView(selectedHabit: selectedHabit),
    );
  }
}

class _CreateCustomHabitView extends StatefulWidget {
  const _CreateCustomHabitView({this.selectedHabit});

  final Habit? selectedHabit;

  @override
  State<_CreateCustomHabitView> createState() => _CreateCustomHabitViewState();
}

class _CreateCustomHabitViewState extends State<_CreateCustomHabitView> {
  late final TextEditingController _nameController;
  late final ToggleSwitchController _habitTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _habitTypeController = ToggleSwitchController();

    // Prefill data if a habit is selected
    if (widget.selectedHabit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _prefillHabitData();
      });
    }
  }

  void _prefillHabitData() {
    final Habit? habit = widget.selectedHabit;
    if (habit == null) {
      return;
    }

    final CreateCustomHabitBloc habitBloc = context
        .read<CreateCustomHabitBloc>();
    final AlarmBloc alarmBloc = context.read<AlarmBloc>();

    // Set name
    _nameController.text = habit.label;
    habitBloc
      ..add(NameChanged(habit.label))
      // Set habit icon (predefined habit)
      ..add(HabitIconSelected(habit))
      // Set color
      ..add(ColorSelected(habit.color(context.appColors)))
      // Set goal value
      ..add(
        GoalValueChanged(
          GoalValue(value: habit.goalValue, unit: habit.goalUnit),
        ),
      )
      // Set goal frequency
      ..add(GoalFrequencyChanged(habit.goalFrequency))
      // Set goal days
      ..add(GoalDaysChanged(habit.goalDays));

    // Set alarm data
    if (habit.isAlarmEnabled && habit.alarmTime != null) {
      alarmBloc
        ..add(const ToggleAlarmEvent(true))
        ..add(UpdateAlarmTimeEvent(habit.alarmTime!));
      if (habit.alarmDays != null) {
        alarmBloc.add(UpdateAlarmDaysEvent(habit.alarmDays!));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _habitTypeController.dispose();
    super.dispose();
  }

  Future<void> _showIconPicker(final BuildContext context) async {
    final CreateCustomHabitBloc bloc = context.read<CreateCustomHabitBloc>();
    final CreateCustomHabitState currentState = bloc.state;

    final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (final BuildContext dialogContext) => IconPickerDialog(
        selectedIcon: currentState.selectedIcon,
        selectedHabit: currentState.selectedHabit,
      ),
    );

    if (result != null && context.mounted) {
      if (result.containsKey('icon')) {
        bloc.add(IconSelected(result['icon']));
      } else if (result.containsKey('habit')) {
        bloc.add(HabitIconSelected(result['habit']));
      }
    }
  }

  Future<void> _showColorPicker(
    final BuildContext context,
    final Color currentColor,
  ) async {
    final CreateCustomHabitBloc bloc = context.read<CreateCustomHabitBloc>();

    final Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (final BuildContext dialogContext) =>
          ColorPickerDialog(selectedColor: currentColor),
    );

    if (selectedColor != null && context.mounted) {
      bloc.add(ColorSelected(selectedColor));
    }
  }

  @override
  Widget build(final BuildContext context) {
    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<CreateCustomHabitBloc, CreateCustomHabitState>(
          listener:
              (final BuildContext context, final CreateCustomHabitState state) {
                if (state.isSaved) {
                  context.router.pop(true);
                  ToastUtils.showToast(
                    context,
                    context.locale.habitCreatedSuccessfully,
                    success: true,
                  );
                }

                if (state.errorMessage != null) {
                  ToastUtils.showToast(
                    context,
                    state.errorMessage ?? context.locale.retry,
                    success: false,
                  );
                }
              },
        ),
        BlocListener<AlarmBloc, AlarmState>(
          listener: (final BuildContext context, final AlarmState state) {
            if (state.status == AlarmStatus.error) {
              ToastUtils.showToast(
                context,
                state.errorMessage ?? 'Alarm error occurred',
                success: false,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(title: context.locale.createCustomHabit),
        backgroundColor: context.appColors.cF6F9FF,

        bottomNavigationBar: BlocBuilder<AlarmBloc, AlarmState>(
          builder: (final BuildContext context, final AlarmState alarmState) {
            return BlocBuilder<CreateCustomHabitBloc, CreateCustomHabitState>(
              builder:
                  (
                    final BuildContext context,
                    final CreateCustomHabitState habitState,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 24,
                      ),
                      child: CustomButton(
                        label: context.locale.addHabit,
                        enabled: habitState.isValid && !habitState.isLoading,
                        onPressed: () {
                          context.read<CreateCustomHabitBloc>().add(
                            SaveHabitPressed(
                              isAlarmEnabled: alarmState.isAlarmEnabled,
                              alarmTime: alarmState.selectedTime,
                              alarmDays: alarmState.selectedDays,
                            ),
                          );
                        },
                      ),
                    );
                  },
            );
          },
        ),
        body: BlocBuilder<CreateCustomHabitBloc, CreateCustomHabitState>(
          builder:
              (final BuildContext context, final CreateCustomHabitState state) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  children: <Widget>[
                    CreateCustomHabitText(
                      text: context.locale.name.toUpperCase(),
                    ),
                    ProfileTextField(
                      controller: _nameController,
                      onChanged: (final String value) {
                        context.read<CreateCustomHabitBloc>().add(
                          NameChanged(value),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CreateCustomHabitText(
                      text: context.locale.iconAndColor.toUpperCase(),
                    ),
                    const SizedBox(height: 8),
                    IconColorRow(
                      selectedIcon: state.selectedIcon,
                      selectedHabit: state.selectedHabit,
                      selectedColor: state.selectedColor,
                      onIconTap: () => _showIconPicker(context),
                      onColorTap: () =>
                          _showColorPicker(context, state.selectedColor),
                    ),
                    const SizedBox(height: 16),
                    CreateCustomHabitText(
                      text: context.locale.goal.toUpperCase(),
                    ),
                    const SizedBox(height: 8),
                    GoalCard(
                      frequency: state.goalFrequency,
                      goalValue: state.goalValue,
                      goalUnit: state.goalUnit,
                      selectedDays: state.goalDays,
                      onGoalChanged: (final GoalValue goalValue) {
                        context.read<CreateCustomHabitBloc>().add(
                          GoalValueChanged(goalValue),
                        );
                      },
                      onFrequencyChanged: (final RepeatInterval frequency) {
                        context.read<CreateCustomHabitBloc>().add(
                          GoalFrequencyChanged(frequency),
                        );
                      },
                      onDaysChanged: (final List<Day> days) {
                        context.read<CreateCustomHabitBloc>().add(
                          GoalDaysChanged(days),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CreateCustomHabitText(
                      text: context.locale.reminders.toUpperCase(),
                    ),
                    const SizedBox(height: 8),

                    BlocBuilder<AlarmBloc, AlarmState>(
                      builder:
                          (
                            final BuildContext context,
                            final AlarmState alarmState,
                          ) {
                            return ReminderCard(
                              frequency: state.goalFrequency,
                              times: state.goalValue,
                              selectedDays: alarmState.selectedDays,
                              isAlarmEnabled: alarmState.isAlarmEnabled,
                              selectedTime: alarmState.selectedTime,
                              onAlarmToggled: (final bool value) {
                                context.read<AlarmBloc>().add(
                                  ToggleAlarmEvent(value),
                                );
                              },
                              onTimeChanged: (final TimeOfDay time) {
                                context.read<AlarmBloc>().add(
                                  UpdateAlarmTimeEvent(time),
                                );
                              },
                              onDaysChanged: (final List<Day> days) {
                                context.read<AlarmBloc>().add(
                                  UpdateAlarmDaysEvent(days),
                                );
                              },
                            );
                          },
                    ),

                    const SizedBox(height: 16),
                    CreateCustomHabitText(
                      text: context.locale.type.toUpperCase(),
                    ),
                    const SizedBox(height: 8),
                    CustomToggleSwitch(
                      controller: _habitTypeController,
                      leftText: context.locale.build,
                      rightText: context.locale.quit,
                      inactiveBackgroundColor: context.appColors.cF3F4F6,
                      activeBackgroundColor: context.appColors.white,
                      activeTextColor: context.appColors.c3843FF,
                      inactiveTextColor: context.appColors.c686873,
                      padding: EdgeInsets.zero,
                      onChanged: (final bool value) {},
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
        ),
      ),
    );
  }
}
