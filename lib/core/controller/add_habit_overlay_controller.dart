import 'package:flutter/material.dart';

class AddHabitOverlayController {
  final ValueNotifier<bool> isOpen = ValueNotifier(false);
  OverlayEntry? _overlayEntry;

  void toggle({
    required BuildContext context,
    required OverlayEntry Function() overlayBuilder,
  }) {
    if (isOpen.value) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      isOpen.value = false;
    } else {
      _overlayEntry = overlayBuilder();
      Overlay.of(context).insert(_overlayEntry!);
      isOpen.value = true;
    }
  }

  void close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    isOpen.value = false;
  }

  void dispose() {
    _overlayEntry?.remove();
    isOpen.dispose();
  }
}
