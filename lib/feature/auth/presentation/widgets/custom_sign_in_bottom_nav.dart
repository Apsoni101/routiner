import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/next_button.dart';

class CustomSignInBottomNav extends StatelessWidget {
  const CustomSignInBottomNav({
    required this.onCreateAccountPressed,
    required this.onNextPressed,
    this.nextEnabled = true,
    super.key,
  });

  final VoidCallback onCreateAccountPressed;
  final VoidCallback onNextPressed;

  final bool nextEnabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shrinkWrap: true,
        children: <Widget>[
          TextButton(
            onPressed: onCreateAccountPressed,
            child: Text(
              context.locale.dontHaveAccountLetsCreate,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: context.appColors.c3843FF,
              ),
            ),
          ),
          const SizedBox(height: 14),

          NextButton(
            onPressed: onNextPressed,
            enabled: nextEnabled,
          ),
        ],
      ),
    );
  }
}
