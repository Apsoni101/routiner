import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/emojis.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_text_field.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/presentation/bloc/create_challenge_bloc/create_challenge_bloc.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_button.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

@RoutePage()
class CreateChallengeScreen extends StatelessWidget {
  const CreateChallengeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<CreateChallengeBloc>(
      create: (_) =>
          AppInjector.getIt<CreateChallengeBloc>()..add(const LoadUserHabits()),
      child: const _CreateChallengeView(),
    );
  }
}

class _CreateChallengeView extends StatefulWidget {
  const _CreateChallengeView();

  @override
  State<_CreateChallengeView> createState() => _CreateChallengeViewState();
}

class _CreateChallengeViewState extends State<_CreateChallengeView> {
  late final _ChallengeFormController _formController;

  @override
  void initState() {
    super.initState();
    _formController = _ChallengeFormController();
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _handleCreateChallenge(final BuildContext context) {
    context.read<CreateChallengeBloc>().add(const CreateChallengePressed());
  }

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<CreateChallengeBloc, CreateChallengeState>(
      listener: _handleBlocStateChanges,
      builder: (final BuildContext context, final CreateChallengeState state) {
        return PopScope(
          canPop: !state.isCreating,
          onPopInvokedWithResult: (final bool didPop, final Object? result) {
            if (didPop && state.isSuccess) {
              context.router.pop(true);
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(title: context.locale.createChallenge),
            backgroundColor: context.appColors.cF6F9FF,
            bottomNavigationBar: _buildBottomButton(context, state),
            body: _ChallengeFormView(
              formController: _formController,
              state: state,
            ),
          ),
        );
      },
    );
  }

  void _handleBlocStateChanges(
    final BuildContext context,
    final CreateChallengeState state,
  ) {
    if (state.isSuccess) {
      ToastUtils.showToast(
        context,
        context.locale.challengeCreatedSuccessfully,
        success: true,
      );
      this.context.router.pop(true);
    } else if (state.errorMessage != null && !state.isCreating) {
      ToastUtils.showToast(context, state.errorMessage!, success: false);
    }
  }

  Widget _buildBottomButton(
    final BuildContext context,
    final CreateChallengeState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: CustomButton(
        label: context.locale.createChallenge,
        enabled: state.isValid && !state.isCreating,
        onPressed: () => _handleCreateChallenge(context),
      ),
    );
  }
}

class _ChallengeFormController {
  _ChallengeFormController() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    durationController = TextEditingController(text: '30');
  }

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController durationController;

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
  }
}

class _ChallengeFormView extends StatelessWidget {
  const _ChallengeFormView({required this.formController, required this.state});

  final _ChallengeFormController formController;
  final CreateChallengeState state;

  @override
  Widget build(final BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _TitleSection(controller: formController.titleController),
        const SizedBox(height: 24),
        _EmojiSection(selectedEmoji: state.emoji),
        const SizedBox(height: 24),
        _DurationSection(
          controller: formController.durationController,
          durationType: state.durationType,
        ),
        const SizedBox(height: 24),
        _DescriptionSection(controller: formController.descriptionController),
        const SizedBox(height: 24),
        _HabitsSection(state: state),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
        color: context.appColors.slate,
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle(context.locale.title.toUpperCase()),
        const SizedBox(height: 8),
        FormTextField(
          controller: controller,
          hintText: context.locale.challengeNameHint,
          onChanged: (final String value) {
            context.read<CreateChallengeBloc>().add(UpdateTitle(value));
          },
        ),
      ],
    );
  }
}

class _EmojiSection extends StatelessWidget {
  const _EmojiSection({required this.selectedEmoji});

  final Emoji selectedEmoji;

  Future<void> _showEmojiPicker(final BuildContext context) async {
    final Emoji? emoji = await showDialog<Emoji>(
      context: context,
      builder: (_) => _EmojiPickerDialog(selectedEmoji: selectedEmoji),
    );

    if (emoji != null && context.mounted) {
      context.read<CreateChallengeBloc>().add(UpdateEmoji(emoji));
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle(context.locale.selectIconTitle.toUpperCase()),
        const SizedBox(height: 8),
        _SelectableContainer(
          height: 80,
          onTap: () => _showEmojiPicker(context),
          child: Center(
            child: Text(
              selectedEmoji.symbol,
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
      ],
    );
  }
}

class _DurationSection extends StatelessWidget {
  const _DurationSection({
    required this.controller,
    required this.durationType,
  });

  final TextEditingController controller;
  final ChallengeDurationType durationType;

  Future<void> _selectDate(final BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = now.add(const Duration(days: 30));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (final BuildContext context, final Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.appColors.c3843FF,
              onPrimary: context.appColors.white,
              surface: context.appColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      final int durationInDays = pickedDate.difference(now).inDays;
      controller.text = _formatDate(pickedDate);
      context.read<CreateChallengeBloc>().add(UpdateDuration(durationInDays));
    }
  }

  String _formatDate(final DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle(context.locale.duration.toUpperCase()),
        const SizedBox(height: 8),
        _SelectableContainer(
          height: 56,
          onTap: () => _selectDate(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: context.appColors.c686873,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.text.isEmpty
                        ? context.locale.selectEndDate
                        : controller.text,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: controller.text.isEmpty
                          ? context.appColors.c686873
                          : context.appColors.c040415,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: context.appColors.c686873,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle(context.locale.description.toUpperCase()),
        const SizedBox(height: 8),
        FormTextField(
          controller: controller,
          hintText: context.locale.descriptionHint,
          maxLines: 4,
          onChanged: (final String value) {
            context.read<CreateChallengeBloc>().add(UpdateDescription(value));
          },
        ),
      ],
    );
  }
}

class _HabitsSection extends StatelessWidget {
  const _HabitsSection({required this.state});

  final CreateChallengeState state;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle(
          context.locale.habitsCount(state.selectedHabits.length).toUpperCase(),
        ),
        const SizedBox(height: 8),
        if (state.isLoadingHabits)
          const Center(child: CircularProgressIndicator())
        else if (state.availableHabits.isEmpty)
          _NoHabitsAvailable()
        else
          _HabitsList(
            availableHabits: state.availableHabits,
            selectedHabits: state.selectedHabits,
          ),
      ],
    );
  }
}

class _NoHabitsAvailable extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.c686873),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.info_outline, size: 32, color: context.appColors.slate),
            const SizedBox(height: 8),
            Text(
              context.locale.noHabitsAvailable,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: context.appColors.slate,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitsList extends StatelessWidget {
  const _HabitsList({
    required this.availableHabits,
    required this.selectedHabits,
  });

  final List<CustomHabitEntity> availableHabits;
  final List<CustomHabitEntity> selectedHabits;

  void _toggleHabit(
    final BuildContext context,
    final CustomHabitEntity habit,
    final bool? value,
  ) {
    final List<CustomHabitEntity> updated;

    if (value ?? false) {
      updated = <CustomHabitEntity>[...selectedHabits, habit];
    } else {
      updated = selectedHabits
          .where((final CustomHabitEntity h) => h.id != habit.id)
          .toList();
    }

    context.read<CreateChallengeBloc>().add(UpdateSelectedHabits(updated));
  }

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.c686873),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: availableHabits.length,
        separatorBuilder: (final BuildContext context, final int index) =>
            Divider(
              height: 1,
              color: context.appColors.c686873.withValues(alpha: 0.2),
            ),
        itemBuilder: (final BuildContext context, final int index) {
          final CustomHabitEntity habit = availableHabits[index];
          final bool isSelected = selectedHabits.any(
            (final CustomHabitEntity h) => h.id == habit.id,
          );

          return CheckboxListTile(
            title: Text(
              habit.name ?? context.locale.unnamed,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            value: isSelected,
            activeColor: context.appColors.c3843FF,
            onChanged: (final bool? value) =>
                _toggleHabit(context, habit, value),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          );
        },
      ),
    );
  }
}

class _SelectableContainer extends StatelessWidget {
  const _SelectableContainer({
    required this.child,
    required this.onTap,
    this.height,
  });

  final Widget child;
  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.appColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.c686873),
        ),
        child: child,
      ),
    );
  }
}

class _EmojiPickerDialog extends StatelessWidget {
  const _EmojiPickerDialog({required this.selectedEmoji});

  final Emoji selectedEmoji;

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.locale.selectEmoji,
              style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: Emoji.values.length,
                itemBuilder: (final BuildContext context, final int index) =>
                    _EmojiGridItem(
                      emoji: Emoji.values[index],
                      isSelected: Emoji.values[index] == selectedEmoji,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiGridItem extends StatelessWidget {
  const _EmojiGridItem({required this.emoji, required this.isSelected});

  final Emoji emoji;
  final bool isSelected;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, emoji),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.c3843FF.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(emoji.symbol, style: const TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}
