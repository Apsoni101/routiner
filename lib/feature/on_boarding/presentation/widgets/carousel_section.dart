import 'package:flutter/material.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'carousel_content.dart';

class CarouselSection extends StatefulWidget {
  const CarouselSection({super.key});

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.heightOf(context) * 0.58,
          child: PageView(
            controller: _controller,
            children: <Widget>[
              CarouselContent(
                image: AppAssets.carouselImgOne,
                title: context.locale.createGoodHabits,
                description: context
                    .locale
                    .changeYourLifeBySlowlyAddingNewHealthyHabitsAndStickingToThem,
              ),
              CarouselContent(
                image: AppAssets.carouselImgTwo,
                title: context.locale.trackYourProgress,
                description: context
                    .locale
                    .everydayYouBecomeOneStepCloserToYourGoalDontGiveUp,
              ),
              CarouselContent(
                image: AppAssets.carouselImgThree,
                title: context.locale.stayTogetherAndStrong,
                description: context
                    .locale
                    .findFriendsToDiscussCommonTopicsCompleteChallengesTogether,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: SlideEffect(
              dotHeight: 8,
              dotWidth: 8,
              dotColor: context.appColors.softIndigo,
              activeDotColor: context.appColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
