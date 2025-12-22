import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/home/presentation/bloc/home_bloc.dart';
import 'package:routiner/feature/home/presentation/widgets/home_header.dart';
import 'package:routiner/feature/home/presentation/widgets/home_tabs.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const CircularProgressIndicator();
        }

        if (state is HomeLoaded) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              '${context.locale.hi} ${state.name} ${context.locale.handshakeEmoji}',
              style: AppTextStyles.airbnbCerealW500S18Lh24Ls0
                  .copyWith(color: context.appColors.c040415),
            ),
            subtitle: Text(
              context.locale.letsMakeHabitsTogether,
              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                  .copyWith(color: context.appColors.c9B9BA1),
            ),
            trailing: CircleAvatar(
              backgroundColor:
              (state.mood?.color ?? Colors.blue).withValues(alpha: 0.6),
              radius: 24,
              child: Text(
                state.mood?.emoji ?? '😇',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
