import 'package:auto_route/auto_route.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/core/navigation/auth_guard.dart';
import 'package:routiner/core/navigation/route_paths.dart';
import 'package:routiner/core/navigation/router/auth_router.dart';
import 'package:routiner/core/navigation/router/dashboard_router.dart';
import 'package:routiner/feature/splash/presentation/screens/splash_screen.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard = AppInjector.getIt<AuthGuard>();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: SplashRoute.page, path: RoutePaths.splash, initial: true),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: CreateAccountRoute.page, ),
    authRoute,
    dashboardRoute(authGuard),
  ];
}
