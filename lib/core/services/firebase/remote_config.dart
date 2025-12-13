import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RemoteConfig {
  RemoteConfig._();

  static Future<void> setup() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 30),
        ),
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('RemoteConfig PlatformException: $e');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('RemoteConfig config setting error: $e');
      }
    }

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('RemoteConfig fetch/parse error: $e');
      }
      rethrow;
    }
  }
}
