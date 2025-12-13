import 'package:flutter/material.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Widget> items;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      height: 64,
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(64),
        border: Border.all(color: context.appColors.cCDCDD0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(items.length, (final int index) {
          if (index == 2 && items.length == 5) {
            return items[index];
          }

          final navIndex = index > 2 ? index - 1 : index;
          return InkWell(
            onTap: () => onTap(navIndex),
            child: items[index],
          );
        }),
      ),
    );
  }
}