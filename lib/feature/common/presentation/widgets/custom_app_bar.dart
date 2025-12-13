import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      backgroundColor: context.appColors.white,
      leadingWidth: 92,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: CustomBackButton(
          onPressed: () {
            context.router.pop();
          },
        ),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
          color: context.appColors.c040415,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Divider(height: 2, color: context.appColors.cEAECF0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
