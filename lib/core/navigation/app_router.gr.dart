// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i21;

import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i19;
import 'package:routiner/core/enums/habits.dart' as _i20;
import 'package:routiner/core/navigation/router/auth_router.dart' as _i2;
import 'package:routiner/core/navigation/router/dashboard_router.dart' as _i6;
import 'package:routiner/feature/activity/presentation/screen/activity_screen.dart'
    as _i1;
import 'package:routiner/feature/auth/presentation/screens/sign_in_screen.dart'
    as _i14;
import 'package:routiner/feature/auth/presentation/screens/sign_up_screen.dart'
    as _i15;
import 'package:routiner/feature/club_chat/presentation/screen/club_chat_screen.dart'
    as _i3;
import 'package:routiner/feature/common/presentation/screens/dashboard_screen.dart'
    as _i7;
import 'package:routiner/feature/create_custom_habit/presentation/screens/create_custom_habit_screen.dart'
    as _i5;
import 'package:routiner/feature/explore/presentation/screen/explore_screen.dart'
    as _i8;
import 'package:routiner/feature/habits_list/presentation/screen/habits_list_screen.dart'
    as _i9;
import 'package:routiner/feature/home/domain/entity/club_entity.dart' as _i18;
import 'package:routiner/feature/home/presentation/screen/home_screen.dart'
    as _i10;
import 'package:routiner/feature/on_boarding/presentation/screens/onboarding_screen.dart'
    as _i11;
import 'package:routiner/feature/profile/presentation/screen/create_profile_screen.dart'
    as _i4;
import 'package:routiner/feature/profile/presentation/screen/profile_screen.dart'
    as _i12;
import 'package:routiner/feature/settings/presentation/screen/activity_screen.dart'
    as _i13;
import 'package:routiner/feature/splash/presentation/screens/splash_screen.dart'
    as _i16;

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i17.PageRouteInfo<void> {
  const ActivityRoute({List<_i17.PageRouteInfo>? children})
    : super(ActivityRoute.name, initialChildren: children);

  static const String name = 'ActivityRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActivityScreen();
    },
  );
}

/// generated route for
/// [_i2.AuthRouterPage]
class AuthRouter extends _i17.PageRouteInfo<void> {
  const AuthRouter({List<_i17.PageRouteInfo>? children})
    : super(AuthRouter.name, initialChildren: children);

  static const String name = 'AuthRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthRouterPage();
    },
  );
}

/// generated route for
/// [_i3.ClubChatScreen]
class ClubChatRoute extends _i17.PageRouteInfo<ClubChatRouteArgs> {
  ClubChatRoute({
    required _i18.ClubEntity club,
    required String currentUserId,
    required void Function(String) onMemberRemoved,
    required _i19.VoidCallback onLeaveClub,
    _i19.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         ClubChatRoute.name,
         args: ClubChatRouteArgs(
           club: club,
           currentUserId: currentUserId,
           onMemberRemoved: onMemberRemoved,
           onLeaveClub: onLeaveClub,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ClubChatRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClubChatRouteArgs>();
      return _i3.ClubChatScreen(
        club: args.club,
        currentUserId: args.currentUserId,
        onMemberRemoved: args.onMemberRemoved,
        onLeaveClub: args.onLeaveClub,
        key: args.key,
      );
    },
  );
}

class ClubChatRouteArgs {
  const ClubChatRouteArgs({
    required this.club,
    required this.currentUserId,
    required this.onMemberRemoved,
    required this.onLeaveClub,
    this.key,
  });

  final _i18.ClubEntity club;

  final String currentUserId;

  final void Function(String) onMemberRemoved;

  final _i19.VoidCallback onLeaveClub;

  final _i19.Key? key;

  @override
  String toString() {
    return 'ClubChatRouteArgs{club: $club, currentUserId: $currentUserId, onMemberRemoved: $onMemberRemoved, onLeaveClub: $onLeaveClub, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClubChatRouteArgs) return false;
    return club == other.club &&
        currentUserId == other.currentUserId &&
        onLeaveClub == other.onLeaveClub &&
        key == other.key;
  }

  @override
  int get hashCode =>
      club.hashCode ^
      currentUserId.hashCode ^
      onLeaveClub.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i4.CreateAccountScreen]
class CreateAccountRoute extends _i17.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i17.PageRouteInfo>? children})
    : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i4.CreateAccountScreen();
    },
  );
}

/// generated route for
/// [_i5.CreateCustomHabitScreen]
class CreateCustomHabitRoute
    extends _i17.PageRouteInfo<CreateCustomHabitRouteArgs> {
  CreateCustomHabitRoute({
    _i19.Key? key,
    _i20.Habit? selectedHabit,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         CreateCustomHabitRoute.name,
         args: CreateCustomHabitRouteArgs(
           key: key,
           selectedHabit: selectedHabit,
         ),
         initialChildren: children,
       );

  static const String name = 'CreateCustomHabitRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateCustomHabitRouteArgs>(
        orElse: () => const CreateCustomHabitRouteArgs(),
      );
      return _i5.CreateCustomHabitScreen(
        key: args.key,
        selectedHabit: args.selectedHabit,
      );
    },
  );
}

class CreateCustomHabitRouteArgs {
  const CreateCustomHabitRouteArgs({this.key, this.selectedHabit});

  final _i19.Key? key;

  final _i20.Habit? selectedHabit;

  @override
  String toString() {
    return 'CreateCustomHabitRouteArgs{key: $key, selectedHabit: $selectedHabit}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateCustomHabitRouteArgs) return false;
    return key == other.key && selectedHabit == other.selectedHabit;
  }

  @override
  int get hashCode => key.hashCode ^ selectedHabit.hashCode;
}

/// generated route for
/// [_i6.DashboardRouterPage]
class DashboardRouter extends _i17.PageRouteInfo<void> {
  const DashboardRouter({List<_i17.PageRouteInfo>? children})
    : super(DashboardRouter.name, initialChildren: children);

  static const String name = 'DashboardRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.DashboardRouterPage();
    },
  );
}

/// generated route for
/// [_i7.DashboardScreen]
class DashboardRoute extends _i17.PageRouteInfo<void> {
  const DashboardRoute({List<_i17.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i7.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i8.ExploreScreen]
class ExploreRoute extends _i17.PageRouteInfo<void> {
  const ExploreRoute({List<_i17.PageRouteInfo>? children})
    : super(ExploreRoute.name, initialChildren: children);

  static const String name = 'ExploreRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i8.ExploreScreen();
    },
  );
}

/// generated route for
/// [_i9.HabitsListScreen]
class HabitsListRoute extends _i17.PageRouteInfo<HabitsListRouteArgs> {
  HabitsListRoute({
    required DateTime date,
    _i19.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         HabitsListRoute.name,
         args: HabitsListRouteArgs(date: date, key: key),
         initialChildren: children,
       );

  static const String name = 'HabitsListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HabitsListRouteArgs>();
      return _i9.HabitsListScreen(date: args.date, key: args.key);
    },
  );
}

class HabitsListRouteArgs {
  const HabitsListRouteArgs({required this.date, this.key});

  final DateTime date;

  final _i19.Key? key;

  @override
  String toString() {
    return 'HabitsListRouteArgs{date: $date, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HabitsListRouteArgs) return false;
    return date == other.date && key == other.key;
  }

  @override
  int get hashCode => date.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i10.HomeScreen]
class HomeRoute extends _i17.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i19.Key? key,
    void Function(_i19.VoidCallback)? onHabitChanged,
    int initialTab = 0,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(
           key: key,
           onHabitChanged: onHabitChanged,
           initialTab: initialTab,
         ),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i10.HomeScreen(
        key: args.key,
        onHabitChanged: args.onHabitChanged,
        initialTab: args.initialTab,
      );
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.onHabitChanged, this.initialTab = 0});

  final _i19.Key? key;

  final void Function(_i19.VoidCallback)? onHabitChanged;

  final int initialTab;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, onHabitChanged: $onHabitChanged, initialTab: $initialTab}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HomeRouteArgs) return false;
    return key == other.key && initialTab == other.initialTab;
  }

  @override
  int get hashCode => key.hashCode ^ initialTab.hashCode;
}

/// generated route for
/// [_i11.OnboardingScreen]
class OnboardingRoute extends _i17.PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    _i19.Key? key,
    _i21.Future<void> Function({bool isFromSignup})? onLoggedIn,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         OnboardingRoute.name,
         args: OnboardingRouteArgs(key: key, onLoggedIn: onLoggedIn),
         initialChildren: children,
       );

  static const String name = 'OnboardingRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingRouteArgs>(
        orElse: () => const OnboardingRouteArgs(),
      );
      return _i11.OnboardingScreen(key: args.key, onLoggedIn: args.onLoggedIn);
    },
  );
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({this.key, this.onLoggedIn});

  final _i19.Key? key;

  final _i21.Future<void> Function({bool isFromSignup})? onLoggedIn;

  @override
  String toString() {
    return 'OnboardingRouteArgs{key: $key, onLoggedIn: $onLoggedIn}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnboardingRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i12.ProfileScreen]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i12.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i13.SettingsScreen]
class SettingsRoute extends _i17.PageRouteInfo<void> {
  const SettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i13.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i14.SignInScreen]
class SignInRoute extends _i17.PageRouteInfo<SignInRouteArgs> {
  SignInRoute({
    _i19.Key? key,
    _i21.Future<void> Function({bool isFromSignup})? onLoggedIn,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         SignInRoute.name,
         args: SignInRouteArgs(key: key, onLoggedIn: onLoggedIn),
         initialChildren: children,
       );

  static const String name = 'SignInRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignInRouteArgs>(
        orElse: () => const SignInRouteArgs(),
      );
      return _i14.SignInScreen(key: args.key, onLoggedIn: args.onLoggedIn);
    },
  );
}

class SignInRouteArgs {
  const SignInRouteArgs({this.key, this.onLoggedIn});

  final _i19.Key? key;

  final _i21.Future<void> Function({bool isFromSignup})? onLoggedIn;

  @override
  String toString() {
    return 'SignInRouteArgs{key: $key, onLoggedIn: $onLoggedIn}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignInRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i15.SignUpScreen]
class SignUpRoute extends _i17.PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    _i19.Key? key,
    _i21.Future<void> Function({bool isFromSignup})? onLoggedIn,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         SignUpRoute.name,
         args: SignUpRouteArgs(key: key, onLoggedIn: onLoggedIn),
         initialChildren: children,
       );

  static const String name = 'SignUpRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpRouteArgs>(
        orElse: () => const SignUpRouteArgs(),
      );
      return _i15.SignUpScreen(key: args.key, onLoggedIn: args.onLoggedIn);
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({this.key, this.onLoggedIn});

  final _i19.Key? key;

  final _i21.Future<void> Function({bool isFromSignup})? onLoggedIn;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, onLoggedIn: $onLoggedIn}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignUpRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i16.SplashScreen]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i16.SplashScreen();
    },
  );
}
