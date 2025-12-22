import 'package:flutter/material.dart';

class MonthDateSelectorController {
  MonthDateSelectorController({required final int initialIndex})
    : selectedIndexNotifier = ValueNotifier<int>(initialIndex),
      scrollController = ScrollController();
  final ValueNotifier<int> selectedIndexNotifier;
  final ScrollController scrollController;

  void selectDate(final int index, {final double itemWidth = 56}) {
    selectedIndexNotifier.value = index;
    scrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    selectedIndexNotifier.dispose();
    scrollController.dispose();
  }
}
