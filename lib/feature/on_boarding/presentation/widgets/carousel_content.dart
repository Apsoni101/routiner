import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class CarouselContent extends StatelessWidget {
  const CarouselContent({
    required this.image,
    required this.title,
    required this.description,
    super.key,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Image.asset(
          image,
          height: MediaQuery.heightOf(context) * 0.4,
          fit: BoxFit.fitWidth,
        ),
        Text(
          title,
          textAlign: TextAlign.start,
          style: AppTextStyles.airbnbCerealW700S40Lh48Ls1.copyWith(
            color: context.appColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.start,
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.cd7d9ff,
          ),
        ),
      ],
    );
  }
}
