import 'package:flutter/material.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class CommonWaveBottomSheet extends StatelessWidget {
  const CommonWaveBottomSheet({
    required this.child,
    super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(final BuildContext context) {
    return ClipPath(
      // clipper: _TopWaveClipper(),
      child: ColoredBox(
        color: context.appColors.white,
        child: Padding(
          padding:
          padding ?? const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Top wave clipper (REUSED as-is)
/// ---------------------------------------------------------------------------
class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(final Size size) {
    const double cornerRadius = 52;
    const double notchDepth = 20;
    const double notchWidth = 140;
    const double topPadding = 30;
    const double smoothness = 0.6;

    final double centerX = size.width / 2;

    final Path path = Path()
      ..moveTo(0, topPadding + cornerRadius)
      ..quadraticBezierTo(0, topPadding, cornerRadius, topPadding)
      ..lineTo(centerX - notchWidth / 2, topPadding)
      ..cubicTo(
        centerX - notchWidth / 2 * smoothness,
        topPadding,
        centerX - notchWidth / 4,
        topPadding - notchDepth,
        centerX,
        topPadding - notchDepth,
      )
      ..cubicTo(
        centerX + notchWidth / 4,
        topPadding - notchDepth,
        centerX + notchWidth / 2 * smoothness,
        topPadding,
        centerX + notchWidth / 2,
        topPadding,
      )
      ..lineTo(size.width - cornerRadius, topPadding)
      ..quadraticBezierTo(
        size.width,
        topPadding,
        size.width,
        topPadding + cornerRadius,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
