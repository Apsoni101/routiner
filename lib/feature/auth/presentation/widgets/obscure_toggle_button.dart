import 'package:flutter/material.dart';

class ObscureToggleButton extends StatelessWidget {
  const ObscureToggleButton({
    required this.isObscured,
    required this.onTap,
    required this.color,
    super.key,
  });

  final bool isObscured;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          isObscured ? Icons.visibility_off : Icons.visibility,
          size: 20,
          color: color,
        ),
      ),
    );
  }
}
