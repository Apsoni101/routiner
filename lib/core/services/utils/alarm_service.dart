import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';

class AlarmService {
  /// Initialize the alarm plugin
  Future<void> initialize() async {
    await Alarm.init();
  }

  /// Schedule an alarm for a specific day
  Future<void> scheduleAlarm({
    required int id,
    required TimeOfDay time,
    required Day day,
    required String title,
    required String body,
  }) async {
    final now = DateTime.now();
    DateTime alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Calculate next occurrence of the selected day
    final targetWeekday = _mapDayToWeekday(day);
    final currentWeekday = now.weekday;

    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd < 0 || (daysToAdd == 0 && now.isAfter(alarmDateTime))) {
      daysToAdd += 7;
    }

    alarmDateTime = alarmDateTime.add(Duration(days: daysToAdd));

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: alarmDateTime,
      assetAudioPath: 'assets/audio/alarm.mp3',
      // Use a named constructor fixed or fade
      volumeSettings: VolumeSettings.fixed(
        volume: 0.8,
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: 'Stop',
      ),
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  /// Cancel a specific alarm
  Future<void> cancelAlarm(int id) async {
    await Alarm.stop(id);
  }

  /// Cancel all alarms
  Future<void> cancelAllAlarms() async {
    final alarms = await Alarm.getAlarms();
    for (final alarm in alarms) {
      await Alarm.stop(alarm.id);
    }
  }

  /// Check if an alarm is set
  Future<bool> isAlarmSet(int id) async {
    final alarms = await Alarm.getAlarms();
    return alarms.any((alarm) => alarm.id == id);
  }

  /// Get all scheduled alarms
  Future<List<AlarmSettings>> getAllAlarms() async {
    return await Alarm.getAlarms();
  }

  /// Map Day enum to weekday number
  int _mapDayToWeekday(Day day) {
    switch (day) {
      case Day.monday:
        return DateTime.monday;
      case Day.tuesday:
        return DateTime.tuesday;
      case Day.wednesday:
        return DateTime.wednesday;
      case Day.thursday:
        return DateTime.thursday;
      case Day.friday:
        return DateTime.friday;
      case Day.saturday:
        return DateTime.saturday;
      case Day.sunday:
        return DateTime.sunday;
      case Day.everyday:
      // If everyday, just schedule for today (user UI can re‑schedule daily)
        return DateTime.now().weekday;
    }
  }
}
