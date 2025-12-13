import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      final TextEditingValue oldValue,
      final TextEditingValue newValue,
      ) {
    String text = newValue.text;

    // Remove non-digits
    text = text.replaceAll(RegExp('[^0-9]'), '');

    // Max 8 digits (MMDDYYYY)
    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    String formatted = '';

    if (text.length >= 2) {
      formatted += '${text.substring(0, 2)}/';
    } else if (text.isNotEmpty) {
      formatted = text;
    }

    if (text.length >= 4) {
      formatted += '${text.substring(2, 4)}/';
    } else if (text.length > 2) {
      formatted += text.substring(2);
    }

    if (text.length > 4) {
      formatted += text.substring(4);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
