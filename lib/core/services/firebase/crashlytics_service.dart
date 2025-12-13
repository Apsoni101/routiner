import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsService {
  CrashlyticsService();

  Future<void> initialize() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  Future<void> logError(
    final Exception exception,
    final StackTrace? stackTrace,
  ) async {
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
  }

  Future<void> setUserId(final String userId) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  Future<void> setCustomKey(final String key, final Object value) async {
    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }
}
