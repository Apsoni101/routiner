import 'package:flutter/material.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_ios_new, size: 14),
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: context.appColors.cCDCDD0, ),
        ),
      ),
    );
  }
}
