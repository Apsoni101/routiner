import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/on_boarding/presentation/widgets/auth_button.dart';
import 'package:routiner/feature/on_boarding/presentation/widgets/carousel_section.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onLoggedIn});

  final Future<void> Function({bool isFromSignup})? onLoggedIn;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ValueNotifier<bool> controller = ValueNotifier<bool>(true);

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: SvgPicture.asset(AppAssets.splashBg, fit: BoxFit.cover),
        ),
        Align(
          alignment: const FractionalOffset(0.18, 0.13),
          child: SvgPicture.asset(AppAssets.dotsBg, width: 70, height: 80),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 48),
              // cause of not using list view
              const Expanded(child: CarouselSection()),
              const SizedBox(height: 48),
              AuthButton(
                onPressed: () {
                  context.router.push(
                    SignInRoute(onLoggedIn: widget.onLoggedIn),
                  );
                },
                text: context.locale.continueWithEmail,
                assetName: AppAssets.loginIc,
                verticalPadding: 16,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  AuthButton(
                    onPressed: () {},
                    text: context.locale.apple,
                    assetName: AppAssets.appleIc,
                  ),
                  AuthButton(
                    onPressed: () {},
                    text: context.locale.google,
                    assetName: AppAssets.googleIc,
                  ),
                  AuthButton(
                    onPressed: () {},
                    text: context.locale.facebook,
                    assetName: AppAssets.fbIc,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.locale.byContinuingYouAgreeTermsAndPrivacyPolicy,
                textAlign: TextAlign.center,
                style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                  color: context.appColors.cAFB4FF,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
