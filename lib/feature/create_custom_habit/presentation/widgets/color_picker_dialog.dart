import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_colors.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/color_picker_dialog/color_picker_bloc.dart';

class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({super.key, this.selectedColor});

  final Color? selectedColor;

  static final List<Color> _colors = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF673AB7),
    const Color(0xFF3F51B5),
    const Color(0xFF2196F3),
    const Color(0xFF03A9F4),
    const Color(0xFF00BCD4),
    const Color(0xFF009688),
    const Color(0xFF4CAF50),
    const Color(0xFF8BC34A),
    const Color(0xFFCDDC39),
    const Color(0xFFFFEB3B),
    const Color(0xFFFFC107),
    const Color(0xFFFF9800),
    const Color(0xFFFF5722),
    const Color(0xFF795548),
  ];

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ColorPickerBloc>(
      create: (final BuildContext context) =>
          ColorPickerBloc(selectedColor: selectedColor),
      child: const _ColorPickerDialogContent(),
    );
  }
}

class _ColorPickerDialogContent extends StatelessWidget {
  const _ColorPickerDialogContent();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ColorPickerBloc, ColorPickerState>(
      builder: (final BuildContext context, final ColorPickerState state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 450),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      context.locale.selectColorTitle,
                      style: AppTextStyles.airbnbCerealW500S14Lh20,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.router.pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ColorPreview(color: state.selectedColor),
                const SizedBox(height: 16),
                Expanded(child: _ColorGrid(selectedColor: state.selectedColor)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.router.pop(state.selectedColor),
                    child: Text(context.locale.selectButton),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.color});

  final Color color;

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors appColors = context.appColors;

    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.cCDCDD0),
      ),
      alignment: Alignment.center,
      child: Text(
        context.locale.colorPreview,
        style: AppTextStyles.airbnbCerealW500S14.copyWith(
          color: color.computeLuminance() > 0.5
              ? appColors.black
              : appColors.white,
        ),
      ),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({required this.selectedColor});

  final Color selectedColor;

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors appColors = context.appColors;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: ColorPickerDialog._colors.length,
      itemBuilder: (final BuildContext context, final int index) {
        final Color color = ColorPickerDialog._colors[index];
        final bool isSelected = selectedColor == color;

        return IconButton(
          onPressed: () {
            context.read<ColorPickerBloc>().add(ColorSelected(color));
          },
          style: IconButton.styleFrom(
            backgroundColor: color,
            shape: const CircleBorder(),
            side: BorderSide(
              color: isSelected ? appColors.black : appColors.cCDCDD0,
              width: isSelected ? 3 : 1,
            ),
          ),
          icon: isSelected
              ? Icon(
                  Icons.check,
                  color: color.computeLuminance() > 0.5
                      ? appColors.black
                      : appColors.white,
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
