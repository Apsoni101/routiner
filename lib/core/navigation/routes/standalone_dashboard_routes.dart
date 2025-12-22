import 'package:auto_route/auto_route.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';

final List<AutoRoute> standaloneDashboardRoutes = <AutoRoute>[
  AutoRoute(page: CreateCustomHabitRoute.page),
  AutoRoute(page: HabitsListRoute.page),
  AutoRoute(page: ClubChatRoute.page),
];
