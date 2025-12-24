import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class FriendsAvatarStack extends StatelessWidget {
  const FriendsAvatarStack({
    required this.friendsCount,
    required this.avatarImages,
    super.key,
  });

  final int friendsCount;
  final List<ImageProvider> avatarImages;

  @override
  Widget build(BuildContext context) {
    if (friendsCount <= 0 || avatarImages.isEmpty) {
      return const SizedBox.shrink();
    }

    final int visibleAvatars = avatarImages.length.clamp(0, friendsCount);

    final int extraCount = friendsCount - visibleAvatars;

    final int totalItems = visibleAvatars + (extraCount > 0 ? 1 : 0);

    final double width = 28 + (totalItems - 1) * 18;

    return SizedBox(
      height: 28,
      width: width,
      child: Stack(
        children: [
          for (int i = 0; i < visibleAvatars; i++)
            Positioned(
              left: i * 18,
              child: CircleAvatar(radius: 14, backgroundImage: avatarImages[i]),
            ),
          if (extraCount > 0)
            Positioned(
              left: visibleAvatars * 18,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: context.appColors.cEBECFF,
                child: Text(
                  '+$extraCount',
                  style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                      .copyWith(color: context.appColors.c3843FF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
