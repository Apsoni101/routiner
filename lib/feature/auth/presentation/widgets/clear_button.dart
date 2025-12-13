import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    required this.onTap,
    required this.iconColor,
    required this.backgroundColor,
    super.key,
  });

  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,

        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(Icons.close, size: 14, color: iconColor),
      ),
    );
  }
}
