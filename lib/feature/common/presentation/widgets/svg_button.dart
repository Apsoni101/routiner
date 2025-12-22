import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    required this.svgPath,
    required this.onPressed,
    super.key,
    this.iconSize = 24,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 12,
  });

  final String svgPath;
  final VoidCallback onPressed;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(final BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: iconSize,
      padding: padding,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: borderWidth)
              : BorderSide.none,
        ),
      ),
      icon: SvgPicture.asset(svgPath, width: iconSize, height: iconSize),
    );
  }
}
