import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.showDivider = true,
    this.actions,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool showDivider;
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      backgroundColor: context.appColors.white,
      leadingWidth: showBackButton ? 92 : 24,
      leading: showBackButton
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: CustomBackButton(
          onPressed: () {
            context.router.pop();
          },
        ),
      )
          : const SizedBox.shrink(),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
              color: context.appColors.c040415,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.c686873,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
      bottom: showDivider
          ? PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Divider(height: 2, color: context.appColors.cEAECF0),
      )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (showDivider ? 20 : 0));
}
