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
    return BlocBuilder<MoodBloc, MoodState>(
      builder: (final BuildContext context, final MoodState state) {
        Mood? selectedMood;

        // Handle all possible states
        if (state is MoodLoadSuccess) {
          selectedMood = state.selectedMood;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _moods.map((final Mood mood) {
            final bool isSelected = mood == selectedMood;

            return OutlinedButton(
              onPressed: () {
                context.read<MoodBloc>().add(MoodSelected(mood));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(32, 32),
                padding: const EdgeInsets.all(8),
                side: BorderSide(
                  width: isSelected ? 2 : 1, // Make selected border thicker
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
              child: Text(
                mood.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}