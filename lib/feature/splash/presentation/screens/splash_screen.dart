import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await context.router.replaceAll(<PageRouteInfo<Object?>>[
          const DashboardRoute(),
        ]);
      }
    });
  }

  @override
  Widget build(final BuildContext context) => Stack(
    children: <Widget>[
      Positioned.fill(
        child: SvgPicture.asset(AppAssets.splashBg, fit: BoxFit.cover),
      ),
      Align(child: SvgPicture.asset(AppAssets.routinerLogo)),
    ],
  );
}
