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
  Widget build(final BuildContext context) {
    if (friendsCount <= 0) {
      return const SizedBox.shrink();
    }

    final int visibleAvatars = friendsCount == 1 ? 1 : 2;
    final int extraCount = friendsCount - visibleAvatars;

    return SizedBox(
      width: 70,
      height: 28,
      child: Stack(
        children: <Widget>[
          for (int i = 0; i < visibleAvatars; i++)
            Positioned(
              left: i * 18.0,
              child: CircleAvatar(radius: 14, backgroundImage: avatarImages[i]),
            ),

          if (extraCount > 0)
            Positioned(
              left: visibleAvatars * 18.0,
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
