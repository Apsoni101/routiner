import 'package:get_it/get_it.dart';
import 'package:routiner/core/controller/language_controller.dart';
import 'package:routiner/core/controller/theme_controller.dart';
import 'package:routiner/core/navigation/auth_guard.dart';
import 'package:routiner/core/services/firebase/crashlytics_service.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/storage/shared_prefs_service.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_local_data_source.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:routiner/feature/auth/data/repositories/auth_repo_impl.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_repo.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_usecase.dart';
import 'package:routiner/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:routiner/feature/auth/presentation/bloc/signup_bloc/signup_bloc.dart';

class AppInjector {
  AppInjector._();

  static final GetIt getIt = GetIt.instance;

  static Future<void> setUp() async {
    getIt
      // Core Services
      ..registerLazySingleton(SharedPrefsService.new)
      ..registerLazySingleton(FirebaseAuthService.new)
      ..registerLazySingleton(FirebaseFirestoreService.new)
      ..registerLazySingleton(CrashlyticsService.new)
      ..registerLazySingleton<ThemeController>(
        () => ThemeController(getIt<SharedPrefsService>()),
      )
      ..registerLazySingleton<AuthGuard>(
        () => AuthGuard(firebaseAuthService: getIt<FirebaseAuthService>()),
      )
      ..registerLazySingleton<LanguageController>(
        () => LanguageController(getIt<SharedPrefsService>()),
      )

      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
          sharedPrefsService: getIt<SharedPrefsService>(),
        ),
      )
      ..registerLazySingleton<AuthRepo>(
        () => AuthRepoImpl(
          authRemoteDataSource: getIt<AuthRemoteDataSource>(),
          authLocalDataSource: getIt<AuthLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<AuthUseCase>(
        () => AuthUseCase(authRepo: getIt<AuthRepo>()),
      )
      ..registerFactory(() => LoginBloc(authUseCase: getIt<AuthUseCase>()))
      ..registerFactory(() => SignupBloc(authUseCase: getIt<AuthUseCase>()));
  }
}
