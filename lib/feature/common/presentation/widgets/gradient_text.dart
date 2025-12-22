import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        super.key,
        this.gradient,
        this.style,
        this.color,
      });

  final String text;
  final Gradient? gradient;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (final Rect bounds) {
          return gradient!.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        blendMode: BlendMode.srcIn,
        child: Text(
          text,
          style: style ?? AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase,
        ),
      );
    } else {
      return Text(
        text,
        style: (style ?? AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase)
            .copyWith(color: color ?? Colors.black),
      );
    }
  }
}
