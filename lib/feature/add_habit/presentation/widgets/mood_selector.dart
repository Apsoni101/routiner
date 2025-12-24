// lib/feature/add_habit/presentation/widgets/mood_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/enums/moods.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/add_habit/presentation/bloc%20/mood_bloc.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  static const List<Mood> _moods = Mood.values;

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<MoodBloc, MoodState>(
      listener: (final BuildContext context, final MoodState state) {
        // Show error message if mood save fails
        if (state is MoodError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: context.appColors.red,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (final BuildContext context, final MoodState state) {
        Mood? selectedMood;
        bool isLoading = false;

        // Handle all possible states
        if (state is MoodLoadSuccess) {
          selectedMood = state.selectedMood;
        } else if (state is MoodError) {
          selectedMood = state.selectedMood;
        } else if (state is MoodLoading) {
          isLoading = true;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _moods.map((final Mood mood) {
            final bool isSelected = mood == selectedMood;

            return OutlinedButton(
              onPressed: isLoading
                  ? null // Disable while loading
                  : () {
                      context.read<MoodBloc>().add(MoodSelected(mood));
                    },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(32, 32),
                padding: const EdgeInsets.all(8),
                side: BorderSide(
                  width: isSelected ? 2 : 1,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : context.appColors.cEAECF0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: isLoading && isSelected
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(mood.emoji, style: const TextStyle(fontSize: 20)),
            );
          }).toList(),
        );
      },
    );
  }
}
