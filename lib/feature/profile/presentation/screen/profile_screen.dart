import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/home/presentation/widgets/home_tabs.dart';
import 'package:routiner/feature/profile/presentation/bloc/profile_display_bloc/profile_bloc.dart';
import 'package:routiner/feature/profile/presentation/widgets/achievements_tab_view.dart';
import 'package:routiner/feature/profile/presentation/widgets/activity_tab_view.dart';
import 'package:routiner/feature/profile/presentation/widgets/friends_tab_view.dart';
import 'package:routiner/feature/profile/presentation/widgets/profile_header.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _profileBloc = AppInjector.getIt<ProfileBloc>();

    _loadData();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && !_profileBloc.isClosed) {
        _profileBloc.add(const LoadTotalPoints());
      }
    });
  }

  void _loadData() {
    _profileBloc.add(const LoadCurrentUserProfile());
    _profileBloc.add(const LoadTotalPoints());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: context.appColors.white,
          appBar: CustomAppBar(
            title: context.locale.profile,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SvgIconButton(
                  padding: EdgeInsets.zero,
                  svgPath: AppAssets.settingsIc,
                  onPressed: () {
                    context.router.push(const SettingsRoute());
                  },
                  iconSize: 48,
                ),
              ),
            ],
            showBackButton: false,
            showDivider: false,
          ),
          body: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (final BuildContext context, final ProfileState state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (final BuildContext context, final ProfileState state) {
              if (state is ProfileLoading && state is! ProfileLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError && state is! ProfileLoaded) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(context.locale.errorPrefix),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _loadData();
                        },
                        child: Text(context.locale.retry),
                      ),
                    ],
                  ),
                );
              }

              UserEntity? profile;
              int? totalPoints;
              if (state is ProfileLoaded) {
                profile = state.profile;
                totalPoints = state.totalPoints;
              }

              return Column(
                children: <Widget>[
                  ProfileHeader(
                    name: profile != null
                        ? '${profile.name ?? ''} ${profile.surname ?? ''}'
                              .trim()
                        : context.locale.loading,
                    subtitle: totalPoints?.toString() ?? '0',
                    imagePath: AppAssets.avatar1Png,
                  ),
                  Container(
                    color: context.appColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: HomeTabs(
                      tabs: <String>[
                        context.locale.activity,
                        context.locale.friends,
                        context.locale.achievements,
                      ],
                      onTabChanged: (final int int) {},
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: context.appColors.cEAECF0,
                      child: const TabBarView(
                        children: <Widget>[
                          ActivityTabView(),
                          FriendsTabView(),
                          AchievementsTabView(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
