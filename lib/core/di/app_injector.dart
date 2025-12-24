import 'package:get_it/get_it.dart';
import 'package:routiner/core/controller/language_controller.dart';
import 'package:routiner/core/controller/theme_controller.dart';
import 'package:routiner/core/navigation/auth_guard.dart';
import 'package:routiner/core/services/firebase/crashlytics_service.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/core/services/storage/shared_prefs_service.dart';
import 'package:routiner/feature/activity/data/data_source/local/activity_local_data_source.dart';
import 'package:routiner/feature/activity/data/data_source/remote/activity_remote_data_source.dart';
import 'package:routiner/feature/activity/data/repo_impl/activity_local_repo_impl.dart';
import 'package:routiner/feature/activity/data/repo_impl/activity_remote_repository_impl.dart';
import 'package:routiner/feature/activity/domain/repo/activity_local_repo.dart';
import 'package:routiner/feature/activity/domain/repo/activity_remote_repository.dart';
import 'package:routiner/feature/activity/domain/usecase/activity_local_use_case.dart';
import 'package:routiner/feature/activity/domain/usecase/activity_remote_usecase.dart';
import 'package:routiner/feature/activity/presentation/bloc/activity_bloc/activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/bloc/daily_activity_bloc/daily_activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/bloc/monthly_activity_bloc/monthly_activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/bloc/weekly_activity_bloc/weekly_activity_bloc.dart';
import 'package:routiner/feature/add_habit/data/data_source/mood_local_data_source.dart';
import 'package:routiner/feature/add_habit/data/data_source/mood_remote_data_source.dart';
import 'package:routiner/feature/add_habit/data/repo_impl/mood_local_repository_impl.dart';
import 'package:routiner/feature/add_habit/data/repo_impl/mood_remote_repository_impl.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_local_repository.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_remote_repository.dart';
import 'package:routiner/feature/add_habit/domain/usecase/mood_local_usecase.dart';
import 'package:routiner/feature/add_habit/domain/usecase/mood_remote_usecase.dart';
import 'package:routiner/feature/add_habit/presentation/bloc%20/mood_bloc.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_local_data_source.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:routiner/feature/auth/data/repositories/auth_local_repo_impl.dart';
import 'package:routiner/feature/auth/data/repositories/auth_remote_repo_impl.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_local_repo.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_remote_repo.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_local_usecase.dart';
import 'package:routiner/feature/auth/domain/use_cases/auth_remote_usecase.dart';
import 'package:routiner/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:routiner/feature/auth/presentation/bloc/signup_bloc/signup_bloc.dart';
import 'package:routiner/feature/challenge/data/data_source/local/challenge_local_data_source.dart';
import 'package:routiner/feature/challenge/data/data_source/remote/challenge_remote_data_source.dart';
import 'package:routiner/feature/challenge/data/repo_impl/challenge_local_repository_impl.dart';
import 'package:routiner/feature/challenge/data/repo_impl/challenge_remote_repository_impl.dart';
import 'package:routiner/feature/challenge/domain/repo/challenge_local_repository.dart';
import 'package:routiner/feature/challenge/domain/repo/challenge_remote_repository.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_local_usecase.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_remote_usecase.dart';
import 'package:routiner/feature/challenge/presentation/bloc/challenge_detail_bloc/challenge_detail_bloc.dart';
import 'package:routiner/feature/challenge/presentation/bloc/challenge_list_bloc/challenge_list_bloc.dart';
import 'package:routiner/feature/challenge/presentation/bloc/create_challenge_bloc/create_challenge_bloc.dart';
import 'package:routiner/feature/club_chat/data/data_source/remote/club_chat_remote_data_source.dart';
import 'package:routiner/feature/club_chat/data/repo_impl/club_chat_remote_repo_impl.dart';
import 'package:routiner/feature/club_chat/domain/repo/club_chat_remote_repo.dart';
import 'package:routiner/feature/club_chat/domain/usecase/club_chat_remote_usecase.dart';
import 'package:routiner/feature/club_chat/presentation/bloc/club_chat_bloc/club_chat_bloc.dart';
import 'package:routiner/feature/create_custom_habit/data/data_source/custom_habit_local_data_source.dart';
import 'package:routiner/feature/create_custom_habit/data/data_source/custom_habit_remote_data_source.dart';
import 'package:routiner/feature/create_custom_habit/data/repo_impl/custom_habit_local_repository_impl.dart';
import 'package:routiner/feature/create_custom_habit/data/repo_impl/custom_habit_remote_repository_impl.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/goal_value.dart';
import 'package:routiner/feature/create_custom_habit/domain/repo/custom_habit_local_repository.dart';
import 'package:routiner/feature/create_custom_habit/domain/repo/custom_habit_remote_repository.dart';
import 'package:routiner/feature/create_custom_habit/domain/usecase/create_custom_habit_local_use_case.dart';
import 'package:routiner/feature/create_custom_habit/domain/usecase/create_custom_habit_remote_usecase.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/custom_habit_bloc.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/goal_picker/goal_picker_bloc.dart';
import 'package:routiner/feature/explore/data/data_source/remote/explore_remote_data_source.dart';
import 'package:routiner/feature/explore/data/repo_impl/explore_remote_repo_impl.dart';
import 'package:routiner/feature/explore/domain/repo/explore_remote_repo.dart';
import 'package:routiner/feature/explore/domain/usecase/explore_remote_usecase.dart';
import 'package:routiner/feature/explore/presentation/bloc/explore_bloc/explore_bloc.dart';
import 'package:routiner/feature/habits_list/data/data_source/local_data_source/habits_list_local_data_source.dart';
import 'package:routiner/feature/habits_list/data/data_source/remote_data_source/habits_list_remote_data_source.dart';
import 'package:routiner/feature/habits_list/data/repo_impl/habits_list_local_repository_impl.dart';
import 'package:routiner/feature/habits_list/data/repo_impl/habits_list_remote_repository_impl.dart';
import 'package:routiner/feature/habits_list/domain/repo/habits_list_remote_repository.dart';
import 'package:routiner/feature/habits_list/domain/repo/habits_list_repository.dart';
import 'package:routiner/feature/habits_list/domain/use_case/habits_list_local_usecase.dart';
import 'package:routiner/feature/habits_list/domain/use_case/habits_list_remote_usecase.dart';
import 'package:routiner/feature/habits_list/presentation/bloc/habits_list_bloc.dart';
import 'package:routiner/feature/home/data/data_source/local_data_source/habit_display_local_data_source.dart';
import 'package:routiner/feature/home/data/data_source/local_data_source/home_local_data_source.dart';
import 'package:routiner/feature/home/data/data_source/remote_data_source/club_remote_data_source.dart';
import 'package:routiner/feature/home/data/data_source/remote_data_source/habits_display_remote_data_source.dart';
import 'package:routiner/feature/home/data/repo_impl/club_remote_repo_impl.dart';
import 'package:routiner/feature/home/data/repo_impl/habit_display_local_repository_impl.dart';
import 'package:routiner/feature/home/data/repo_impl/habits_display_remote_repository_impl.dart';
import 'package:routiner/feature/home/data/repo_impl/home_local_repo_impl.dart';
import 'package:routiner/feature/home/domain/repo/club_remote_repo.dart';
import 'package:routiner/feature/home/domain/repo/habit_display_local_repository.dart';
import 'package:routiner/feature/home/domain/repo/habits_display_remote_repository.dart';
import 'package:routiner/feature/home/domain/repo/home_local_repo.dart';
import 'package:routiner/feature/home/domain/usecase/club_usecase.dart';
import 'package:routiner/feature/home/domain/usecase/habit_display_local_usecase.dart';
import 'package:routiner/feature/home/domain/usecase/habits_display_remote_usecase.dart';
import 'package:routiner/feature/home/domain/usecase/home_local_usecase.dart';
import 'package:routiner/feature/home/presentation/bloc/club_bloc/club_list_bloc.dart';
import 'package:routiner/feature/home/presentation/bloc/create_club_bloc/create_club_bloc.dart';
import 'package:routiner/feature/home/presentation/bloc/habit_display_bloc/habit_display_bloc.dart';
import 'package:routiner/feature/home/presentation/bloc/home_bloc.dart';
import 'package:routiner/feature/home/presentation/bloc/update_value_dialog_bloc/update_value_dialog_bloc.dart';
import 'package:routiner/feature/profile/data/data_source/local_data_sources/create_account_local_data_source.dart';
import 'package:routiner/feature/profile/data/data_source/local_data_sources/profile_display_local_data_source.dart';
import 'package:routiner/feature/profile/data/data_source/remote_data_sources/create_account_remote_data_source.dart';
import 'package:routiner/feature/profile/data/data_source/remote_data_sources/friend_remote_data_source.dart';
import 'package:routiner/feature/profile/data/data_source/remote_data_sources/profile_remote_data_source.dart';
import 'package:routiner/feature/profile/data/repo_impl/create_account_local_repository_impl.dart';
import 'package:routiner/feature/profile/data/repo_impl/create_account_remote_repository_impl.dart';
import 'package:routiner/feature/profile/data/repo_impl/friend_remote_repo_impl.dart';
import 'package:routiner/feature/profile/data/repo_impl/profile_local_repo_impl.dart';
import 'package:routiner/feature/profile/data/repo_impl/profile_remote_repo_impl.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_local_repository.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_remote_repository.dart';
import 'package:routiner/feature/profile/domain/repo/friend_remote_repo.dart';
import 'package:routiner/feature/profile/domain/repo/profile_local_repo.dart';
import 'package:routiner/feature/profile/domain/repo/profile_remote_repo.dart';
import 'package:routiner/feature/profile/domain/usecase/create_account_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/create_account_remote_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/friends_remote_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_remote_usecase.dart';
import 'package:routiner/feature/profile/presentation/bloc/activity_tab_bloc/activity_tab_bloc.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_bloc/create_account_bloc.dart';
import 'package:routiner/feature/profile/presentation/bloc/friend_remote_bloc/friend_remote_bloc.dart';
import 'package:routiner/feature/profile/presentation/bloc/profile_display_bloc/profile_bloc.dart';

class AppInjector {
  AppInjector._();

  static final GetIt getIt = GetIt.instance;

  static Future<void> setUp() async {
    getIt
      /// Core Services
      ..registerLazySingleton(SharedPrefsService.new)
      ..registerSingleton<HiveService>(HiveService())
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
      ///DATASOURCE
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<CreateAccountLocalDataSource>(
        () => CreateAccountLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<CreateAccountRemoteDataSource>(
        () => CreateAccountRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<MoodLocalDataSource>(
        () => MoodLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<MoodRemoteDataSource>(
        () => MoodRemoteDataSourceImpl(
          firestoreService: getIt<FirebaseFirestoreService>(),
          authService: getIt<FirebaseAuthService>(),
        ),
      )
      ..registerLazySingleton<ActivityRemoteDataSource>(
        () => ActivityRemoteDataSourceImpl(
          firestoreService: getIt<FirebaseFirestoreService>(),
          authService: getIt<FirebaseAuthService>(),
        ),
      )
      ..registerLazySingleton<ActivityLocalDataSource>(
        () => ActivityLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<HomeLocalDataSource>(
        () => HomeLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<CustomHabitLocalDataSource>(
        () => CustomHabitLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<ChallengeLocalDataSource>(
        () => ChallengeLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<CustomHabitRemoteDataSource>(
        () => CustomHabitRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<HabitDisplayLocalDataSource>(
        () => HabitDisplayLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<HabitsListLocalDataSource>(
        () => HabitsListLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<HabitsListRemoteDataSource>(
        () => HabitsListRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<HabitsDisplayRemoteDataSource>(
        () => HabitsDisplayRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<FriendRemoteDataSource>(
        () => FriendRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<ClubChatRemoteDataSource>(
        () => ClubChatRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<ClubRemoteDataSource>(
        () => ClubRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<ExploreRemoteDataSource>(
        () => ExploreRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<ChallengeRemoteDataSource>(
        () => ChallengeRemoteDataSourceImpl(
          authService: getIt<FirebaseAuthService>(),
          firestoreService: getIt<FirebaseFirestoreService>(),
        ),
      )
      ..registerLazySingleton<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(getIt<HiveService>()),
      )
      ..registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(
          firestoreService: getIt<FirebaseFirestoreService>(),
          authService: getIt<FirebaseAuthService>(),
        ),
      )
      ///Repo
      ..registerLazySingleton<AuthRemoteRepo>(
        () => AuthRemoteRepoImpl(
          authRemoteDataSource: getIt<AuthRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<AuthLocalRepo>(
        () => AuthLocalRepoImpl(
          authLocalDataSource: getIt<AuthLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<ActivityRemoteRepository>(
        () => ActivityRemoteRepositoryImpl(
          remoteDataSource: getIt<ActivityRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<ActivityLocalRepository>(
        () => ActivityLocalRepositoryImpl(getIt<ActivityLocalDataSource>()),
      )
      ..registerLazySingleton<CreateAccountLocalRepository>(
        () => CreateAccountLocalRepositoryImpl(
          getIt<CreateAccountLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<CreateAccountRemoteRepository>(
        () => CreateAccountRemoteRepositoryImpl(
          getIt<CreateAccountRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<MoodLocalRepository>(
        () => MoodLocalRepositoryImpl(getIt<MoodLocalDataSource>()),
      )
      ..registerLazySingleton<MoodRemoteRepository>(
        () => MoodRemoteRepositoryImpl(getIt<MoodRemoteDataSource>()),
      )
      ..registerLazySingleton<HomeLocalRepo>(
        () => HomeLocalRepoImpl(getIt<HomeLocalDataSource>()),
      )
      ..registerLazySingleton<CustomHabitLocalRepository>(
        () =>
            CustomHabitLocalRepositoryImpl(getIt<CustomHabitLocalDataSource>()),
      )
      ..registerLazySingleton<CustomHabitRemoteRepository>(
        () => CustomHabitRemoteRepositoryImpl(
          getIt<CustomHabitRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<HabitDisplayLocalRepository>(
        () => HabitDisplayLocalRepositoryImpl(
          getIt<HabitDisplayLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<HabitsListLocalRepository>(
        () => HabitsListLocalRepositoryImpl(getIt<HabitsListLocalDataSource>()),
      )
      ..registerLazySingleton<ChallengeLocalRepository>(
        () => ChallengeLocalRepositoryImpl(getIt<ChallengeLocalDataSource>()),
      )
      ..registerLazySingleton<HabitsListRemoteRepository>(
        () =>
            HabitsListRemoteRepositoryImpl(getIt<HabitsListRemoteDataSource>()),
      )
      ..registerLazySingleton<HabitsDisplayRemoteRepository>(
        () => HabitsDisplayRemoteRepositoryImpl(
          getIt<HabitsDisplayRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<FriendRemoteRepo>(
        () => FriendRemoteRepoImpl(
          friendRemoteDataSource: getIt<FriendRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<ClubChatRemoteRepository>(
        () => ClubChatRepositoryImpl(
          remoteDataSource: getIt<ClubChatRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<ClubRemoteRepository>(
        () =>
            ClubRepositoryImpl(remoteDataSource: getIt<ClubRemoteDataSource>()),
      )
      ..registerLazySingleton<ExploreRemoteRepository>(
        () => ExploreRemoteRepositoryImpl(
          remoteDataSource: getIt<ExploreRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<ChallengeRemoteRepository>(
        () => ChallengeRemoteRepositoryImpl(getIt<ChallengeRemoteDataSource>()),
      )
      ..registerLazySingleton<ProfileLocalRepo>(
        () => ProfileLocalRepoImpl(
          profileLocalDataSource: getIt<ProfileLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<ProfileRemoteRepo>(
        () => ProfileRemoteRepoImpl(
          profileRemoteDataSource: getIt<ProfileRemoteDataSource>(),
        ),
      )
      ///USE CASES
      ..registerLazySingleton<AuthRemoteUseCase>(
        () => AuthRemoteUseCase(authRemoteRepo: getIt<AuthRemoteRepo>()),
      )
      ..registerLazySingleton<ActivityRemoteUseCase>(
        () => ActivityRemoteUseCase(
          repository: getIt<ActivityRemoteRepository>(),
        ),
      )
      ..registerLazySingleton<ActivityLocalUseCase>(
        () => ActivityLocalUseCase(getIt<ActivityLocalRepository>()),
      )
      ..registerLazySingleton<AuthLocalUseCase>(
        () => AuthLocalUseCase(authLocalRepo: getIt<AuthLocalRepo>()),
      )
      ..registerLazySingleton(
        () => CreateAccountLocalUsecase(getIt<CreateAccountLocalRepository>()),
      )
      ..registerLazySingleton(
        () => ChallengeLocalUsecase(getIt<ChallengeLocalRepository>()),
      )
      ..registerLazySingleton(
        () =>
            CreateAccountRemoteUsecase(getIt<CreateAccountRemoteRepository>()),
      )
      ..registerLazySingleton(
        () => MoodLocalUsecase(getIt<MoodLocalRepository>()),
      )
      ..registerLazySingleton(
        () => MoodRemoteUsecase(getIt<MoodRemoteRepository>()),
      )
      ..registerLazySingleton(() => HomeLocalUsecase(getIt<HomeLocalRepo>()))
      ..registerLazySingleton<HabitDisplayLocalUsecase>(
        () => HabitDisplayLocalUsecase(getIt<HabitDisplayLocalRepository>()),
      )
      ..registerLazySingleton<HabitsListLocalUsecase>(
        () => HabitsListLocalUsecase(getIt<HabitsListLocalRepository>()),
      )
      ..registerLazySingleton<HabitsListRemoteUsecase>(
        () => HabitsListRemoteUsecase(getIt<HabitsListRemoteRepository>()),
      )
      ..registerLazySingleton<HabitsDisplayRemoteUsecase>(
        () =>
            HabitsDisplayRemoteUsecase(getIt<HabitsDisplayRemoteRepository>()),
      )
      ..registerLazySingleton(
        () =>
            CreateCustomHabitLocalUsecase(getIt<CustomHabitLocalRepository>()),
      )
      ..registerLazySingleton(
        () => CreateCustomHabitRemoteUsecase(
          getIt<CustomHabitRemoteRepository>(),
        ),
      )
      ..registerLazySingleton(
        () => FriendsRemoteUsecase(friendRemoteRepo: getIt<FriendRemoteRepo>()),
      )
      ..registerLazySingleton(
        () => ClubChatRemoteUseCase(getIt<ClubChatRemoteRepository>()),
      )
      ..registerLazySingleton(
        () => ClubRemoteUseCase(getIt<ClubRemoteRepository>()),
      )
      ..registerLazySingleton(
        () => ExploreRemoteUseCase(getIt<ExploreRemoteRepository>()),
      )
      ..registerLazySingleton(
        () => ChallengeRemoteUsecase(getIt<ChallengeRemoteRepository>()),
      )
      ..registerLazySingleton<ProfileLocalUseCase>(
        () => ProfileLocalUseCase(profileLocalRepo: getIt<ProfileLocalRepo>()),
      )
      ..registerLazySingleton<ProfileRemoteUseCase>(
        () =>
            ProfileRemoteUseCase(profileRemoteRepo: getIt<ProfileRemoteRepo>()),
      )
      ///BLOCS
      ..registerFactory(
        () => MoodBloc(
          moodLocalUsecase: getIt<MoodLocalUsecase>(),
          moodRemoteUsecase: getIt<MoodRemoteUsecase>(),
        ),
      )
      ..registerFactory(() => HomeBloc(getIt<HomeLocalUsecase>()))
      ..registerFactory(
        () => LoginBloc(
          authRemoteUseCase: getIt<AuthRemoteUseCase>(),
          authLocalUseCase: getIt<AuthLocalUseCase>(),
        ),
      )
      ..registerFactoryParam<GoalPickerBloc, GoalValue, void>(
        (final GoalValue goalValue, _) => GoalPickerBloc(
          initialUnit: goalValue.unit,
          initialValue: goalValue.value,
        ),
      )
      ..registerFactory(
        () => SignupBloc(
          authRemoteUseCase: getIt<AuthRemoteUseCase>(),
          authLocalUseCase: getIt<AuthLocalUseCase>(),
        ),
      )
      ..registerFactory(
        () => HabitDisplayBloc(
          habitDisplayUsecase: getIt<HabitDisplayLocalUsecase>(),
          remoteUsecase: getIt<HabitsDisplayRemoteUsecase>(),
        ),
      )
      ..registerFactory(
        () => UpdateValueDialogBloc(
          habitDisplayUsecase: getIt<HabitDisplayLocalUsecase>(),
        ),
      )
      ..registerFactory(
        () => FriendsRemoteBloc(friendUseCase: getIt<FriendsRemoteUsecase>()),
      )
      ..registerFactory(ActivityBloc.new)
      ..registerFactory(
        () => ClubListBloc(clubUseCase: getIt<ClubRemoteUseCase>()),
      )
      ..registerFactory(
        () => ExploreBloc(exploreUseCase: getIt<ExploreRemoteUseCase>()),
      )
      ..registerFactory(
        () => CreateClubBloc(clubUseCase: getIt<ClubRemoteUseCase>()),
      )
      ..registerFactory(
        () => ClubChatBloc(clubChatUseCase: getIt<ClubChatRemoteUseCase>()),
      )
      ..registerFactory(
        () => HabitsListBloc(
          localUsecase: getIt<HabitsListLocalUsecase>(),
          remoteUsecase: getIt<HabitsListRemoteUsecase>(),
        ),
      )
      ..registerFactory(
        () => CreateCustomHabitBloc(
          createCustomHabitLocalUsecase: getIt<CreateCustomHabitLocalUsecase>(),
          createCustomHabitRemoteUsecase:
              getIt<CreateCustomHabitRemoteUsecase>(),
        ),
      )
      ..registerFactory<ProfileBloc>(
        () => ProfileBloc(
          profileRemoteUseCase: getIt<ProfileRemoteUseCase>(),
          profileLocalUseCase: getIt<ProfileLocalUseCase>(),
        ),
      )
      ..registerFactory(
        () => ChallengeDetailBloc(
          remoteUsecase: getIt<ChallengeRemoteUsecase>(),
          localUsecase: getIt<ChallengeLocalUsecase>(),
        ),
      )
      ..registerFactory(
        () => DailyActivityBloc(
          activityRemoteUseCase: getIt<ActivityRemoteUseCase>(),
          activityLocalUseCase: getIt<ActivityLocalUseCase>(),
        ),
      )
      ..registerFactory(
        () => ActivityTabBloc(
          profileLocalUseCase: getIt<ProfileLocalUseCase>(),
          profileRemoteUseCase: getIt<ProfileRemoteUseCase>(),
        ),
      )
      ..registerFactory(
        () => MonthlyActivityBloc(
          activityRemoteUseCase: getIt<ActivityRemoteUseCase>(),
          activityLocalUseCase: getIt<ActivityLocalUseCase>(),
        ),
      )
      ..registerFactory(
        () => WeeklyActivityBloc(
          activityRemoteUseCase: getIt<ActivityRemoteUseCase>(),
          activityLocalUseCase: getIt<ActivityLocalUseCase>(),
        ),
      )
      ..registerFactory(
        () => ChallengesListBloc(
          remoteUsecase: getIt<ChallengeRemoteUsecase>(),
          localUsecase: getIt<ChallengeLocalUsecase>(),
        ),
      )
      ..registerFactory(
        () => CreateChallengeBloc(
          remoteUsecase: getIt<ChallengeRemoteUsecase>(),
          localUsecase: getIt<ChallengeLocalUsecase>(),
        ),
      )
      ..registerFactory(
        () => CreateAccountBloc(
          remoteUsecase: getIt<CreateAccountRemoteUsecase>(),
          createAccountUsecase: getIt<CreateAccountLocalUsecase>(),
        ),
      );
  }
}
