import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_local_usecase.dart';
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
  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (final BuildContext context) {
        final bloc = AppInjector.getIt<ProfileBloc>();

        // Get current user's UID from auth local usecase
        final authLocalUseCase = AppInjector.getIt<AuthLocalUseCase>();
        final currentUser = authLocalUseCase.getCurrentUser();

        if (currentUser?.uid != null) {
          bloc.add(LoadProfile(uid: currentUser!.uid!));
        }

        return bloc;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: context.appColors.white,
          appBar: CustomAppBar(
            title: context.locale.profile,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SvgIconButton(
                  padding: EdgeInsets.zero,
                  svgPath: AppAssets.settingsIc,
                  onPressed: () {},
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (final BuildContext context, final ProfileState state) {
              if (state is ProfileLoading && state is! ProfileLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading profile',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final authLocalUseCase = AppInjector.getIt<AuthLocalUseCase>();
                          final currentUser = authLocalUseCase.getCurrentUser();

                          if (currentUser?.uid != null) {
                            context.read<ProfileBloc>().add(
                              RefreshProfile(uid: currentUser!.uid!),
                            );
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Get profile data
              UserEntity? profile;
              if (state is ProfileLoaded) {
                profile = state.profile;
              }

              // Build UI with profile data
              return Column(
                children: [
                  ProfileHeader(
                    name: profile != null
                        ? '${profile.name ?? ''} ${profile.surname ?? ''}'.trim()
                        : 'Loading...',
                    subtitle: '1452', // You can add this field to UserEntity if needed
                    imagePath: AppAssets.avatar1Png, // You can add this field to UserEntity if needed
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
                      onTabChanged: (int) {},
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