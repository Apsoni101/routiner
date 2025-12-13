import 'package:flutter/material.dart';

abstract class AppThemeColors {
  Color get white;

  Color get black;

  Color get red;

  Color get electricViolet;

  Color get slate;

  Color get lightSilver;

  Color get darkGrey;

  Color get royalBlue;

  Color get primaryBlue;

  Color get cd7d9ff;

  Color get c040415;

  Color get cAFB4FF;

  Color get cEAECF0;

  Color get c3843FF;

  Color get cF6F9FF;

  Color get c3BA935;

  Color get cCDCDD0;

  Color get c686873;

  Color get softIndigo;

  // Permanent colors
  Color get permanentBlack => Colors.black;
}

class AppColorsDark extends AppThemeColors {
  @override
  Color get white => Colors.white;

  @override
  Color get black => Colors.black;

  @override
  Color get cd7d9ff => const Color(0xFFD7D9FF);

  @override
  Color get c040415 => const Color(0xFF040415);

  @override
  Color get red => const Color(0xFFED1B24);

  @override
  Color get electricViolet => const Color(0xFF9333EA);

  @override
  Color get slate => const Color(0xFF9CA3AF);

  @override
  Color get lightSilver => const Color(0xFFB9B9B9);

  @override
  Color get darkGrey => const Color(0xFF3A3A3A);

  @override
  Color get royalBlue => const Color(0xFF2743FD);

  @override
  Color get primaryBlue => const Color(0xFF2B47FC);

  @override
  Color get softIndigo => const Color(0xFF888EFF);

  @override
  Color get cAFB4FF => const Color(0xFFAFB4FF);

  @override
  Color get cEAECF0 => const Color(0xFFEAECF0);

  @override
  Color get c3843FF => const Color(0xFF3843FF);

  @override
  Color get cF6F9FF => const Color(0xFFF6F9FF);

  @override
  Color get c3BA935 => const Color(0xFF3BA935);

  @override
  Color get cCDCDD0 => const Color(0xFFCDCDD0);

  @override
  Color get c686873 => const Color(0xFF686873);
}

class AppColorsLight extends AppThemeColors {
  @override
  Color get white => Colors.white;

  @override
  Color get black => Colors.black;

  @override
  Color get cd7d9ff => const Color(0xFFD7D9FF);

  @override
  Color get c040415 => const Color(0xFF040415);

  @override
  Color get red => const Color(0xFFED1B24);

  @override
  Color get electricViolet => const Color(0xFF9333EA);

  @override
  Color get slate => const Color(0xFF9CA3AF);

  @override
  Color get lightSilver => const Color(0xFFB9B9B9);

  @override
  Color get darkGrey => const Color(0xFF3A3A3A);

  @override
  Color get royalBlue => const Color(0xFF2743FD);

  @override
  Color get primaryBlue => const Color(0xFF2B47FC);

  @override
  Color get softIndigo => const Color(0xFF888EFF);

  @override
  Color get cAFB4FF => const Color(0xFFAFB4FF);

  @override
  Color get cEAECF0 => const Color(0xFFEAECF0);

  @override
  Color get c3843FF => const Color(0xFF3843FF);

  @override
  Color get cF6F9FF => const Color(0xFFF6F9FF);

  @override
  Color get c3BA935 => const Color(0xFF3BA935);

  @override
  Color get cCDCDD0 => const Color(0xFFCDCDD0);

  @override
  Color get c686873 => const Color(0xFF686873);
}
