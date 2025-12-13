import 'package:auto_route/auto_route.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/core/navigation/route_paths.dart';

@RoutePage(name: 'AuthRouter')
class AuthRouterPage extends AutoRouter {
  const AuthRouterPage({super.key});
}

final AutoRoute authRoute = AutoRoute(
  page: AuthRouter.page,
  path: RoutePaths.auth,
  children: <AutoRoute>[
    AutoRoute(
      page: OnboardingRoute.page,
      path: RoutePaths.onBoardingScreen,
      initial: true,
    ),
    AutoRoute(page: SignInRoute.page, path: RoutePaths.login),
    AutoRoute(page: SignUpRoute.page, path: RoutePaths.register),
  ],
);
