import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routiner/firebase_options.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/localisation/app_localizations.dart';
import 'package:routiner/core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppInjector.setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final AppRouter appRouter = AppRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Routiner',
      routerConfig: appRouter.config(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
