import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'activity_event.dart';

part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityState.initial()) {
    on<ActivityInitialized>(_onInitialized);
    on<ActivityTabChanged>(_onTabChanged);
    on<ActivityDateNavigated>(_onDateNavigated);
  }

  void _onInitialized(
    final ActivityInitialized event,
    final Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: 0, currentDate: DateTime.now()));
  }

  void _onTabChanged(
    final ActivityTabChanged event,
    final Emitter<ActivityState> emit,
  ) {
    DateTime resetDate;

    switch (event.tabIndex) {
      case 0: // Daily - keep current date
        resetDate = DateTime.now();
        break;

      case 1: // Weekly - set to current week's Monday (or start of week)
        final DateTime now = DateTime.now();
        resetDate = now.subtract(Duration(days: now.weekday - 1));
        break;

      case 2: // Monthly - set to first day of current month
        final DateTime now = DateTime.now();
        resetDate = DateTime(now.year, now.month);
        break;

      default:
        resetDate = DateTime.now();
    }

    emit(
      state.copyWith(selectedTabIndex: event.tabIndex, currentDate: resetDate),
    );
  }

  void _onDateNavigated(
    final ActivityDateNavigated event,
    final Emitter<ActivityState> emit,
  ) {
    DateTime newDate;

    switch (state.selectedTabIndex) {
      case 0: // Daily
        if (event.isNext) {
          newDate = state.currentDate.add(const Duration(days: 1));
        } else {
          newDate = state.currentDate.subtract(const Duration(days: 1));
        }
        break;

      case 1: // Weekly
        if (event.isNext) {
          newDate = state.currentDate.add(const Duration(days: 7));
        } else {
          newDate = state.currentDate.subtract(const Duration(days: 7));
        }
        break;

      case 2: // Monthly
        if (event.isNext) {
          // Move to next month
          final int nextMonth = state.currentDate.month == 12
              ? 1
              : state.currentDate.month + 1;
          final int nextYear = state.currentDate.month == 12
              ? state.currentDate.year + 1
              : state.currentDate.year;
          newDate = DateTime(nextYear, nextMonth);
        } else {
          // Move to previous month
          final int prevMonth = state.currentDate.month == 1
              ? 12
              : state.currentDate.month - 1;
          final int prevYear = state.currentDate.month == 1
              ? state.currentDate.year - 1
              : state.currentDate.year;
          newDate = DateTime(prevYear, prevMonth);
        }
        break;

      default:
        newDate = state.currentDate;
    }

    emit(state.copyWith(currentDate: newDate));
  }
}
