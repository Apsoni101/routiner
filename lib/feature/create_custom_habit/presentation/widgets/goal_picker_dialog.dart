import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide ValueChanged;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/goal_value.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/goal_picker/goal_picker_bloc.dart';

class GoalPickerDialog extends StatelessWidget {
  const GoalPickerDialog({
    required this.currentValue,
    required this.currentUnit,
    super.key,
  });

  final int currentValue;
  final GoalUnit currentUnit;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<GoalPickerBloc>(
      create: (_) => AppInjector.getIt<GoalPickerBloc>(
        param1: GoalValue(value: currentValue, unit: currentUnit),
      ),
      child: const _GoalPickerView(),
    );
  }
}

class _GoalPickerView extends StatelessWidget {
  const _GoalPickerView();

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<GoalPickerBloc, GoalPickerState>(
          builder: (final BuildContext context, final GoalPickerState state) {
            if (state is! GoalPickerReady) {
              return const SizedBox.shrink();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(context.locale.selectGoal),

                const SizedBox(height: 16),

                Text(context.locale.unit),
                const SizedBox(height: 8),

                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: GoalUnit.values.length,
                    separatorBuilder: (_, final __) => const SizedBox(width: 8),
                    itemBuilder: (final BuildContext context, final int index) {
                      final GoalUnit unit = GoalUnit.values[index];

                      return ChoiceChip(
                        label: Text(unit.label(context)),
                        selected: unit == state.unit,
                        onSelected: (_) {
                          context.read<GoalPickerBloc>().add(UnitChanged(unit));
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Text(context.locale.value),
                const SizedBox(height: 8),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  child: ListView.builder(
                    itemCount: state.valueOptions.length,
                    itemBuilder: (_, final int index) {
                      final int value = state.valueOptions[index];

                      return ListTile(
                        title: Text('$value ${state.unit.label(context)}'),
                        trailing: value == state.value
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () {
                          context.read<GoalPickerBloc>().add(
                            ValueChanged(value),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => context.router.pop(),
                      child: Text(context.locale.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        context.router.pop(
                          GoalValue(value: state.value, unit: state.unit),
                        );
                      },
                      child: Text(context.locale.confirm),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
