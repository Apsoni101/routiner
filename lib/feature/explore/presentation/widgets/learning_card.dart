import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({
    required this.imagePath,
    required this.title,
    required this.sectionHeight,
    required this.cardWidth,
    required this.iconPath,
    super.key,
  });

  final String imagePath;
  final String title;
  final String iconPath;
  final double sectionHeight;
  final double cardWidth;

  @override
  Widget build(final BuildContext context) {
    const double borderRadiusValue = 16;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: context.appColors.c000DFF,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Column(
        children: <Widget>[
          // Clip image to match container border radius
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(borderRadiusValue),
            ),
            child: Image.asset(
              imagePath,
              height: sectionHeight * 0.55,
              width: cardWidth,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: sectionHeight * 0.45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(iconPath, width: 20, height: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                        color: context.appColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
