import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class ToastUtils {
  /// Original method replaced with FlutterToast
  static void showToast(
    final BuildContext context,
    final String message, {
    required final bool success,
  }) {
    final FToast fToast = FToast()..init(context);

    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.appColors.cF6F9FF,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (success)
            Image.asset(AppAssets.appLogoIc, width: 24, height: 24)
          else
            Icon(Icons.error_outline, color: context.appColors.red),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.airbnbCerealW500S14.copyWith(
                color: context.appColors.c040415,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 3000),
    );
  }
}
