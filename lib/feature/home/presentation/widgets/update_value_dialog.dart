// lib/feature/habit_display/presentation/widgets/update_value_dialog.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide ValueChanged;
import 'package:flutter/services.dart' hide ValueChanged;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/presentation/bloc/update_value_dialog_bloc/update_value_dialog_bloc.dart';

class UpdateValueDialog extends StatefulWidget {
  const UpdateValueDialog({
    required this.log,
    required this.maxValue,
    required this.currentValue,
    required this.unit,
    required this.habitName,
    super.key,
  });

  final HabitLogEntity log;
  final int maxValue;
  final int currentValue;
  final String unit;
  final String habitName;

  @override
  State<UpdateValueDialog> createState() => _UpdateValueDialogState();
}

class _UpdateValueDialogState extends State<UpdateValueDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<UpdateValueDialogBloc>(
      create: (final BuildContext context) =>
          AppInjector.getIt<UpdateValueDialogBloc>()..add(
            InitializeDialog(
              log: widget.log,
              maxValue: widget.maxValue,
              currentValue: widget.currentValue,
            ),
          ),
      child: BlocConsumer<UpdateValueDialogBloc, UpdateValueDialogState>(
        listener:
            (final BuildContext context, final UpdateValueDialogState state) {
              if (state is UpdateValueDialogSuccess) {
                context.router.pop(true);
              } else if (state is UpdateValueDialogError) {
                ToastUtils.showToast(context, state.message, success: false);
              }
            },
        builder: (final BuildContext context, final UpdateValueDialogState state) {
          final bool isSubmitting = state is UpdateValueDialogSubmitting;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            backgroundColor: context.appColors.cEAECF0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.locale.updateProgress,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      fontSize: 18,
                      color: context.appColors.c040415,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.habitName,
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.c9B9BA1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    autofocus: true,
                    enabled: !isSubmitting,
                    onChanged: (final String value) {
                      context.read<UpdateValueDialogBloc>().add(
                        ValueChanged(value),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: context.locale.enterValue,
                      suffixText: widget.unit.toUpperCase(),
                      helperText: context.locale.maxValueHelper(
                        widget.maxValue,
                        widget.unit.toUpperCase(),
                      ),

                      errorText: state is UpdateValueDialogEditing
                          ? state.errorMessage
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: context.appColors.c3843FF,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                context.router.pop(false);
                              },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          context.locale.cancel,
                          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                            fontSize: 14,
                            color: context.appColors.c9B9BA1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed:
                            !isSubmitting &&
                                state is UpdateValueDialogEditing &&
                                state.errorMessage == null &&
                                state.value.isNotEmpty
                            ? () {
                                context.read<UpdateValueDialogBloc>().add(
                                  const SubmitValue(),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appColors.c3843FF,
                          foregroundColor:  context.appColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: context.appColors.cEAECF0,
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.appColors.white,
                                  ),
                                ),
                              )
                            : Text(
                                context.locale.confirm,
                                style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                                    .copyWith(color:  context.appColors.white),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
