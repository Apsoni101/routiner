import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({
    required this.tabs,
    required this.onTabChanged,
    this.controller,
    super.key,
  });

  final List<String> tabs;
  final ValueChanged<int> onTabChanged;
  final TabController? controller;


  @override
  Widget build(final BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: context.appColors.cEAECF0,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TabBar(
        controller: controller,
        padding: const EdgeInsets.all(2),
        labelPadding: EdgeInsets.zero,
        labelColor: context.appColors.c3843FF,
        labelStyle: AppTextStyles.airbnbCerealW500S14Lh20Ls0,
        unselectedLabelStyle: AppTextStyles
            .airbnbCerealW500S14Lh20Ls0
            .copyWith(color: context.appColors.c686873),
        unselectedLabelColor: context.appColors.c9B9BA1,
        dividerHeight: 0,
        indicator: BoxDecoration(
          color: context.appColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: tabs.map((text) => Tab(text: text)).toList(),
        onTap: onTabChanged,
      ),
    );
  }
}
