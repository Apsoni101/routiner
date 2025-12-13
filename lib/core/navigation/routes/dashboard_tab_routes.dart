import 'package:auto_route/auto_route.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/core/navigation/route_paths.dart';

final List<AutoRoute> dashboardTabRoutes = <AutoRoute>[
  AutoRoute(
    page: DashboardRoute.page,
    initial: true,
    children: <AutoRoute>[
      AutoRoute(page: HomeRoute.page, path: RoutePaths.home, initial: true),
      AutoRoute(page: ExploreRoute.page, path: RoutePaths.explore),
      AutoRoute(page: ActivityRoute.page, path: RoutePaths.activity),
      AutoRoute(page: ProfileRoute.page, path: RoutePaths.profile),
    ],
  ),
];
