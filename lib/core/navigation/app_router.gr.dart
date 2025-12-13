// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i15;

import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;
import 'package:routiner/core/navigation/router/auth_router.dart' as _i2;
import 'package:routiner/core/navigation/router/dashboard_router.dart' as _i4;
import 'package:routiner/feature/activity/presentation/screen/activity_screen.dart'
    as _i1;
import 'package:routiner/feature/auth/presentation/screens/sign_in_screen.dart'
    as _i10;
import 'package:routiner/feature/auth/presentation/screens/sign_up_screen.dart'
    as _i11;
import 'package:routiner/feature/common/presentation/screens/dashboard_screen.dart'
    as _i5;
import 'package:routiner/feature/explore/presentation/screen/explore_screen.dart'
    as _i6;
import 'package:routiner/feature/home/presentation/screen/home_screen.dart'
    as _i7;
import 'package:routiner/feature/on_boarding/presentation/screens/onboarding_screen.dart'
    as _i8;
import 'package:routiner/feature/profile/presentation/screen/create_profile_screen.dart'
    as _i3;
import 'package:routiner/feature/profile/presentation/screen/profile_screen.dart'
    as _i9;
import 'package:routiner/feature/splash/presentation/screens/splash_screen.dart'
    as _i12;

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i13.PageRouteInfo<void> {
  const ActivityRoute({List<_i13.PageRouteInfo>? children})
    : super(ActivityRoute.name, initialChildren: children);

  static const String name = 'ActivityRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActivityScreen();
    },
  );
}

/// generated route for
/// [_i2.AuthRouterPage]
class AuthRouter extends _i13.PageRouteInfo<void> {
  const AuthRouter({List<_i13.PageRouteInfo>? children})
    : super(AuthRouter.name, initialChildren: children);

  static const String name = 'AuthRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthRouterPage();
    },
  );
}

/// generated route for
/// [_i3.CreateAccountScreen]
class CreateAccountRoute extends _i13.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i13.PageRouteInfo>? children})
    : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.CreateAccountScreen();
    },
  );
}

/// generated route for
/// [_i4.DashboardRouterPage]
class DashboardRouter extends _i13.PageRouteInfo<void> {
  const DashboardRouter({List<_i13.PageRouteInfo>? children})
    : super(DashboardRouter.name, initialChildren: children);

  static const String name = 'DashboardRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i4.DashboardRouterPage();
    },
  );
}

/// generated route for
/// [_i5.DashboardScreen]
class DashboardRoute extends _i13.PageRouteInfo<void> {
  const DashboardRoute({List<_i13.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i5.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i6.ExploreScreen]
class ExploreRoute extends _i13.PageRouteInfo<void> {
  const ExploreRoute({List<_i13.PageRouteInfo>? children})
    : super(ExploreRoute.name, initialChildren: children);

  static const String name = 'ExploreRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.ExploreScreen();
    },
  );
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeScreen();
    },
  );
}

/// generated route for
/// [_i8.OnboardingScreen]
class OnboardingRoute extends _i13.PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    _i14.Key? key,
    _i15.Future<void> Function({bool isFromSignup})? onLoggedIn,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         OnboardingRoute.name,
         args: OnboardingRouteArgs(key: key, onLoggedIn: onLoggedIn),
         initialChildren: children,
       );

  static const String name = 'OnboardingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingRouteArgs>(
        orElse: () => const OnboardingRouteArgs(),
      );
      return _i8.OnboardingScreen(key: args.key, onLoggedIn: args.onLoggedIn);
    },
  );
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({this.key, this.onLoggedIn});

  final _i14.Key? key;

  final _i15.Future<void> Function({bool isFromSignup})? onLoggedIn;

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
/// [_i9.ProfileScreen]
class ProfileRoute extends _i13.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i14.Key? key,
    _i14.VoidCallback? onProfileCompleted,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(
           key: key,
           onProfileCompleted: onProfileCompleted,
         ),
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>(
        orElse: () => const ProfileRouteArgs(),
      );
      return _i9.ProfileScreen(
        key: args.key,
        onProfileCompleted: args.onProfileCompleted,
      );
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key, this.onProfileCompleted});

  final _i14.Key? key;

  final _i14.VoidCallback? onProfileCompleted;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, onProfileCompleted: $onProfileCompleted}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileRouteArgs) return false;
    return key == other.key && onProfileCompleted == other.onProfileCompleted;
  }

  @override
  int get hashCode => key.hashCode ^ onProfileCompleted.hashCode;
}

/// generated route for
/// [_i10.SignInScreen]
class SignInRoute extends _i13.PageRouteInfo<SignInRouteArgs> {
  SignInRoute({
    _i14.Key? key,
    _i15.Future<void> Function({bool isFromSignup})? onLoggedIn,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         SignInRoute.name,
         args: SignInRouteArgs(key: key, onLoggedIn: onLoggedIn),
         initialChildren: children,
       );

  static const String name = 'SignInRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignInRouteArgs>(
        orElse: () => const SignInRouteArgs(),
      );
      return _i10.SignInScreen(key: args.key, onLoggedIn: args.onLoggedIn);
    },
  );
}

class SignInRouteArgs {
  const SignInRouteArgs({this.key, this.onLoggedIn});

  final _i14.Key? key;

  final _i15.Future<void> Function({bool isFromSignup})? onLoggedIn;

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
/// [_i11.SignUpScreen]
class SignUpRoute extends _i13.PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    _i14.Key? key,
    _i15.Future<void> Function({bool isFromSignup})? onLoggedIn,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         SignUpRoute.name,
         args: SignUpRouteArgs(key: key, onLoggedIn: onLoggedIn),
         initialChildren: children,
       );

  static const String name = 'SignUpRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpRouteArgs>(
        orElse: () => const SignUpRouteArgs(),
      );
      return _i11.SignUpScreen(key: args.key, onLoggedIn: args.onLoggedIn);
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({this.key, this.onLoggedIn});

  final _i14.Key? key;

  final _i15.Future<void> Function({bool isFromSignup})? onLoggedIn;

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
/// [_i12.SplashScreen]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute({List<_i13.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i12.SplashScreen();
    },
  );
}
