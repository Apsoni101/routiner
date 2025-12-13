import 'package:flutter/widgets.dart';
import 'package:routiner/core/localisation/app_localizations.dart';

extension AppLocaleExtension on BuildContext {
  /// Access localized strings directly: context.locale.appName
  AppLocalizations get locale => AppLocalizations.of(this);
}
