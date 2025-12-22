import 'package:flutter/material.dart';

class ToggleSwitchController extends ValueNotifier<bool> {
  ToggleSwitchController({final bool initialValue = false})
    : super(initialValue);

  bool get isRightSelected => value;

  void selectLeft() => value = false;

  void selectRight() => value = true;

  void toggle() => value = !value;
}
