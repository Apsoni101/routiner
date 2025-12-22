import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/controller/toggle_switch_controller.dart';

class CustomToggleSwitch extends StatelessWidget {
  const CustomToggleSwitch({
    required this.controller,
    required this.leftText,
    required this.rightText,
    required this.activeBackgroundColor,
    required this.inactiveBackgroundColor,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.onChanged,
    super.key,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(4),
    this.textStyle,
  });

  final ToggleSwitchController controller;
  final String leftText;
  final String rightText;

  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;
  final Color activeTextColor;
  final Color inactiveTextColor;

  final ValueChanged<bool> onChanged;

  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (final BuildContext context, final bool isRightSelected, _) {
        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: inactiveBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: <Widget>[
              _ToggleItem(
                text: leftText,
                isActive: !isRightSelected,
                activeBgColor: activeBackgroundColor,
                inactiveBgColor: Colors.transparent,
                activeTextColor: activeTextColor,
                inactiveTextColor: inactiveTextColor,
                borderRadius: borderRadius,
                onTap: () {
                  controller.selectLeft();
                  onChanged(false);
                },
                textStyle: textStyle,
              ),
              _ToggleItem(
                text: rightText,
                isActive: isRightSelected,
                activeBgColor: activeBackgroundColor,
                inactiveBgColor: Colors.transparent,
                activeTextColor: activeTextColor,
                inactiveTextColor: inactiveTextColor,
                borderRadius: borderRadius,
                onTap: () {
                  controller.selectRight();
                  onChanged(true);
                },
                textStyle: textStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.text,
    required this.isActive,
    required this.activeBgColor,
    required this.inactiveBgColor,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.borderRadius,
    required this.onTap,
    this.textStyle,
  });

  final String text;
  final bool isActive;
  final Color activeBgColor;
  final Color inactiveBgColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final double borderRadius;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  @override
  Widget build(final BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? activeBgColor : inactiveBgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: (textStyle ?? AppTextStyles.airbnbCerealW500S14Lh20Ls0)
                .copyWith(
                  color: isActive ? activeTextColor : inactiveTextColor,
                ),
          ),
        ),
      ),
    );
  }
}
