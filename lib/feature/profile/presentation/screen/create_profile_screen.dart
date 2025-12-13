import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/image_button.dart';
import 'package:routiner/feature/common/presentation/widgets/next_button.dart';
import 'package:routiner/feature/profile/bloc/create_account_bloc.dart';
import 'package:routiner/feature/profile/presentation/widgets/complete_button.dart';
import 'package:routiner/feature/profile/presentation/widgets/selectable_grid_item.dart';

@RoutePage()
class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: const _CreateProfileView(),
    );
  }
}

class _CreateProfileView extends StatefulWidget {
  const _CreateProfileView();

  @override
  State<_CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<_CreateProfileView> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> _genders = [
    {'label': 'Male', 'icon': Icons.male},
    {'label': 'Female', 'icon': Icons.female},
  ];

  final List<Map<String, dynamic>> _habits = [
    {'label': 'Meditation', 'icon': Icons.self_improvement},
    {'label': 'Sleep', 'icon': Icons.bedtime},
    {'label': 'Study', 'icon': Icons.menu_book},
    {'label': 'Run', 'icon': Icons.directions_run},
    {'label': 'Drink Water', 'icon': Icons.water_drop},
    {'label': 'Exercise', 'icon': Icons.fitness_center},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => previous.currentPage != current.currentPage,
      listener: (context, state) {
        _controller.animateToPage(
          state.currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        backgroundColor: context.appColors.cF6F9FF,
        appBar: CustomAppBar(title: context.locale.createAccount),
        bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: NextButton(
                onPressed: () {
                  if (state.currentPage == 1) {
                    // Complete profile creation
                    // Navigate to next screen
                  } else {
                    context.read<ProfileBloc>().add(NextPageRequested());
                  }
                },
                enabled: state.canProceed,
              ),
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // First page for selecting gender
                    _buildGenderPage(context),

                    // Second page for selecting habits
                    _buildHabitsPage(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderPage(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.locale.chooseYourGender,
              style: AppTextStyles.airbnbCerealW500S18Lh24Ls0
                  .copyWith(color: context.appColors.c040415),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _genders.length,
                itemBuilder: (context, index) {
                  final gender = _genders[index];
                  return SelectableGridItem(
                    label: gender['label'],
                    icon: gender['icon'],
                    isSelected: state.selectedGender == gender['label'],
                    onTap: () {
                      context.read<ProfileBloc>().add(
                        GenderSelected(gender['label']),
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

  Widget _buildHabitsPage(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.locale.chooseYourFirstHabits,
              style: AppTextStyles.airbnbCerealW500S18Lh24Ls0
                  .copyWith(color: context.appColors.c040415),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              context.locale.youMayAddMoreHabitsLater,
              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                  .copyWith(color: context.appColors.c686873),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return SelectableGridItem(
                    label: habit['label'],
                    icon: habit['icon'],
                    isSelected: state.selectedHabits.contains(habit['label']),
                    onTap: () {
                      context.read<ProfileBloc>().add(
                        HabitToggled(habit['label']),
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