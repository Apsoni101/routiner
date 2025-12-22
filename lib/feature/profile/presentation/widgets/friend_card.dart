import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    required this.friend,
    required this.assetPath,
    required this.onPressed,
    super.key,
  });

  final UserEntity friend;
  final String assetPath;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.appColors.white,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          child: Text(
            friend.name?[0].toUpperCase() ?? 'U',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${friend.name ?? ''} ${friend.surname ?? ''}',
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.c040415,
          ),
        ),
        subtitle: Text(
          '100 points',
          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
            color: context.appColors.c9B9BA1,
          ),
        ),
        trailing: SvgIconButton(
          svgPath: assetPath,
          iconSize: 36,
          padding: EdgeInsets.zero,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
