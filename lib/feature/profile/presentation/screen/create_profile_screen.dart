// lib/feature/profile/presentation/screens/create_account_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/next_button.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_bloc.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_event.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_state.dart';
import 'package:routiner/feature/profile/presentation/widgets/selectable_grid_item.dart';

@RoutePage()
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<CreateAccountBloc>(
      create: (_) => AppInjector.getIt<CreateAccountBloc>(),
      child: const _CreateAccountView(),
    );
  }
}

class _CreateAccountView extends StatefulWidget {
  const _CreateAccountView();

  @override
  State<_CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<_CreateAccountView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<CreateAccountBloc, CreateAccountState>(
          listenWhen:
              (
                final CreateAccountState previous,
                final CreateAccountState current,
              ) {
                if (previous is CreateAccountData &&
                    current is CreateAccountData) {
                  return previous.currentPage != current.currentPage;
                }
                return false;
              },
          listener:
              (final BuildContext context, final CreateAccountState state) {
                if (state is CreateAccountData) {
                  _pageController.animateToPage(
                    state.currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
        ),
        BlocListener<CreateAccountBloc, CreateAccountState>(
          listenWhen:
              (
                final CreateAccountState previous,
                final CreateAccountState current,
              ) =>
                  current is CreateAccountSuccess ||
                  current is CreateAccountError ||
                  current is CreateAccountLoading,
          listener:
              (final BuildContext context, final CreateAccountState state) {
                if (state is CreateAccountLoading) {
                  // Show loading indicator
                  ToastUtils.showToast(
                    context,
                    'Saving your account...',
                    success: true,
                  );
                } else if (state is CreateAccountSuccess) {
                  // Navigate to dashboard with home screen
                  context.router.replaceAll(<PageRouteInfo<Object?>>[
                    const DashboardRouter(
                      children: <PageRouteInfo<Object?>>[HomeRoute()],
                    ),
                  ]);
                } else if (state is CreateAccountError) {
                  ToastUtils.showToast(context, state.message, success: true);
                }
              },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.appColors.cF6F9FF,
        appBar: CustomAppBar(title: context.locale.createAccount),
        bottomNavigationBar: BlocBuilder<CreateAccountBloc, CreateAccountState>(
          builder:
              (final BuildContext context, final CreateAccountState state) {
                if (state is! CreateAccountData) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40,
                    left: 24,
                    right: 24,
                  ),
                  child: NextButton(
                    enabled: state.canProceed,
                    onPressed: () {
                      if (state.currentPage == 1) {
                        // Save account data and navigate to home
                        context.read<CreateAccountBloc>().add(
                          const SaveAccountRequested(),
                        );
                      } else {
                        // Go to next page
                        context.read<CreateAccountBloc>().add(
                          const NextPageRequested(),
                        );
                      }
                    },
                  ),
                );
              },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const <Widget>[_GenderPage(), _HabitsPage()],
          ),
        ),
      ),
    );
  }
}

class _GenderPage extends StatelessWidget {
  const _GenderPage();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (final BuildContext context, final CreateAccountState state) {
        if (state is! CreateAccountData) {
          return const SizedBox.shrink();
        }

        const List<Gender> genders = Gender.values;

        return Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.locale.chooseYourGender,
              style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: genders.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (final BuildContext context, final int index) {
                  final Gender gender = genders[index];
                  return SelectableGridItem(
                    label: gender.label,
                    iconPath: gender.path,
                    isSelected: state.selectedGender == gender,
                    onTap: () {
                      context.read<CreateAccountBloc>().add(
                        GenderSelected(gender),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HabitsPage extends StatelessWidget {
  const _HabitsPage();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (final BuildContext context, final CreateAccountState state) {
        if (state is! CreateAccountData) {
          return const SizedBox.shrink();
        }

        const List<Habit> habits = Habit.values;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.locale.chooseYourFirstHabits,
              style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.locale.youMayAddMoreHabitsLater,
              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                color: context.appColors.c686873,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: habits.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (final BuildContext context, final int index) {
                  final Habit habit = habits[index];

                  return SelectableGridItem(
                    label: habit.label,
                    iconPath: habit.path,
                    isSelected: state.selectedHabits.contains(habit),
                    onTap: () {
                      context.read<CreateAccountBloc>().add(
                        HabitToggled(habit),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
