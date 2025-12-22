import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Routiner'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get profile;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-MAIL'**
  String get email;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @dontHaveAccountLetsCreate.
  ///
  /// In en, this message translates to:
  /// **'Don’t have account? Let’s create!'**
  String get dontHaveAccountLetsCreate;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with E-mail'**
  String get continueWithEmail;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go!'**
  String get letsGo;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be empty'**
  String get emailEmptyError;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get passwordEmptyError;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get nameEmptyError;

  /// No description provided for @surnameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Surname can\'t be empty'**
  String get surnameEmptyError;

  /// No description provided for @birthdateEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Birthdate can\'t be empty'**
  String get birthdateEmptyError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotPassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'SURNAME'**
  String get surname;

  /// No description provided for @enterSurname.
  ///
  /// In en, this message translates to:
  /// **'Enter your surname'**
  String get enterSurname;

  /// No description provided for @createGoodHabits.
  ///
  /// In en, this message translates to:
  /// **'Create\nGood Habits'**
  String get createGoodHabits;

  /// No description provided for @changeYourLifeBySlowlyAddingNewHealthyHabitsAndStickingToThem.
  ///
  /// In en, this message translates to:
  /// **'Change your life by slowly adding new healthy habits and sticking to them.'**
  String get changeYourLifeBySlowlyAddingNewHealthyHabitsAndStickingToThem;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @byContinuingYouAgreeTermsAndPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree Terms of Services & Privacy Policy.'**
  String get byContinuingYouAgreeTermsAndPrivacyPolicy;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'UserName'**
  String get userName;

  /// No description provided for @trackYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Track\nYour Progress'**
  String get trackYourProgress;

  /// No description provided for @everydayYouBecomeOneStepCloserToYourGoalDontGiveUp.
  ///
  /// In en, this message translates to:
  /// **'Everyday you become one step closer to your goal. Don’t give up!'**
  String get everydayYouBecomeOneStepCloserToYourGoalDontGiveUp;

  /// No description provided for @stayTogetherAndStrong.
  ///
  /// In en, this message translates to:
  /// **'Stay Together\nand Strong'**
  String get stayTogetherAndStrong;

  /// No description provided for @findFriendsToDiscussCommonTopicsCompleteChallengesTogether.
  ///
  /// In en, this message translates to:
  /// **'Find friends to discuss common topics. Complete challenges together.'**
  String get findFriendsToDiscussCommonTopicsCompleteChallengesTogether;

  /// No description provided for @userNameExample.
  ///
  /// In en, this message translates to:
  /// **'Your UserName'**
  String get userNameExample;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'BIRTHDATE'**
  String get birthdate;

  /// No description provided for @birthdateExample.
  ///
  /// In en, this message translates to:
  /// **'mm/dd/yyyy'**
  String get birthdateExample;

  /// No description provided for @dobExample.
  ///
  /// In en, this message translates to:
  /// **'Your birthday (dd-mm-yyyy)'**
  String get dobExample;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'business.vors@gmail.com'**
  String get emailExample;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @chooseYourGender.
  ///
  /// In en, this message translates to:
  /// **'Choose your gender'**
  String get chooseYourGender;

  /// No description provided for @chooseYourFirstHabits.
  ///
  /// In en, this message translates to:
  /// **'Choose your first habits'**
  String get chooseYourFirstHabits;

  /// No description provided for @youMayAddMoreHabitsLater.
  ///
  /// In en, this message translates to:
  /// **'You may add more habits later'**
  String get youMayAddMoreHabitsLater;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged In Successfully'**
  String get loginSuccess;

  /// No description provided for @quitBadHabit.
  ///
  /// In en, this message translates to:
  /// **'Quit Bad Habit'**
  String get quitBadHabit;

  /// No description provided for @newGoodHabit.
  ///
  /// In en, this message translates to:
  /// **'New Good Habit'**
  String get newGoodHabit;

  /// No description provided for @newGoodHabitUpper.
  ///
  /// In en, this message translates to:
  /// **'New Good Habit'**
  String get newGoodHabitUpper;

  /// No description provided for @neverTooLate.
  ///
  /// In en, this message translates to:
  /// **'Never too late...'**
  String get neverTooLate;

  /// No description provided for @forABetterLife.
  ///
  /// In en, this message translates to:
  /// **'For a better life'**
  String get forABetterLife;

  /// No description provided for @addMood.
  ///
  /// In en, this message translates to:
  /// **'Add Mood'**
  String get addMood;

  /// No description provided for @addHabit.
  ///
  /// In en, this message translates to:
  /// **'Add Habit'**
  String get addHabit;

  /// No description provided for @createCustomHabit.
  ///
  /// In en, this message translates to:
  /// **'Create Custom Habit'**
  String get createCustomHabit;

  /// No description provided for @popularHabits.
  ///
  /// In en, this message translates to:
  /// **'POPULAR Habıts'**
  String get popularHabits;

  /// No description provided for @moodAngry.
  ///
  /// In en, this message translates to:
  /// **'😡'**
  String get moodAngry;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'☹️'**
  String get moodSad;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'😐'**
  String get moodNeutral;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'🙂'**
  String get moodHappy;

  /// No description provided for @moodLove.
  ///
  /// In en, this message translates to:
  /// **'😍'**
  String get moodLove;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How’re you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @iconAndColor.
  ///
  /// In en, this message translates to:
  /// **'Icon and Color'**
  String get iconAndColor;

  /// No description provided for @walking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @goalTimesPerDay.
  ///
  /// In en, this message translates to:
  /// **'1 times or more per day'**
  String get goalTimesPerDay;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @reminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Remember to set off time for a workout today.'**
  String get reminderDescription;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'09:30'**
  String get reminderTime;

  /// No description provided for @reminderEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get reminderEveryDay;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminder;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Habit type'**
  String get type;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @iconDefault.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get iconDefault;

  /// No description provided for @iconFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get iconFitness;

  /// No description provided for @iconReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get iconReading;

  /// No description provided for @iconSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get iconSleep;

  /// No description provided for @iconWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get iconWater;

  /// No description provided for @iconFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get iconFood;

  /// No description provided for @iconRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get iconRunning;

  /// No description provided for @iconMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get iconMeditation;

  /// No description provided for @iconIdeas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get iconIdeas;

  /// No description provided for @iconArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get iconArt;

  /// No description provided for @iconMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get iconMusic;

  /// No description provided for @iconMovies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get iconMovies;

  /// No description provided for @iconShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get iconShopping;

  /// No description provided for @iconWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get iconWork;

  /// No description provided for @iconStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get iconStudy;

  /// No description provided for @iconFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get iconFavorite;

  /// No description provided for @iconHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get iconHealth;

  /// No description provided for @iconDrink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get iconDrink;

  /// No description provided for @iconNoSmoking.
  ///
  /// In en, this message translates to:
  /// **'No Smoking'**
  String get iconNoSmoking;

  /// No description provided for @iconCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get iconCleaning;

  /// No description provided for @iconPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get iconPets;

  /// No description provided for @iconGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get iconGarden;

  /// No description provided for @iconSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get iconSunny;

  /// No description provided for @iconNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get iconNight;

  /// No description provided for @iconBeach.
  ///
  /// In en, this message translates to:
  /// **'Beach'**
  String get iconBeach;

  /// No description provided for @iconSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get iconSwimming;

  /// No description provided for @iconSoccer.
  ///
  /// In en, this message translates to:
  /// **'Soccer'**
  String get iconSoccer;

  /// No description provided for @iconBasketball.
  ///
  /// In en, this message translates to:
  /// **'Basketball'**
  String get iconBasketball;

  /// No description provided for @iconGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get iconGaming;

  /// No description provided for @iconComputer.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get iconComputer;

  /// No description provided for @iconPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get iconPhotography;

  /// No description provided for @iconWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get iconWriting;

  /// No description provided for @iconRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get iconRecording;

  /// No description provided for @iconListening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get iconListening;

  /// No description provided for @iconPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get iconPizza;

  /// No description provided for @iconCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get iconCoffee;

  /// No description provided for @iconDessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get iconDessert;

  /// No description provided for @iconFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get iconFastFood;

  /// No description provided for @iconHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get iconHospital;

  /// No description provided for @iconMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get iconMedical;

  /// No description provided for @iconMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get iconMedicine;

  /// No description provided for @iconMentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get iconMentalHealth;

  /// No description provided for @iconMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get iconMood;

  /// No description provided for @iconStar.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get iconStar;

  /// No description provided for @iconAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get iconAchievement;

  /// No description provided for @iconTrophy.
  ///
  /// In en, this message translates to:
  /// **'Trophy'**
  String get iconTrophy;

  /// No description provided for @iconCelebration.
  ///
  /// In en, this message translates to:
  /// **'Celebration'**
  String get iconCelebration;

  /// No description provided for @iconSpa.
  ///
  /// In en, this message translates to:
  /// **'Spa'**
  String get iconSpa;

  /// No description provided for @iconHotTub.
  ///
  /// In en, this message translates to:
  /// **'Hot Tub'**
  String get iconHotTub;

  /// No description provided for @iconBath.
  ///
  /// In en, this message translates to:
  /// **'Bath'**
  String get iconBath;

  /// No description provided for @iconShower.
  ///
  /// In en, this message translates to:
  /// **'Shower'**
  String get iconShower;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorDeepPurple.
  ///
  /// In en, this message translates to:
  /// **'Deep Purple'**
  String get colorDeepPurple;

  /// No description provided for @colorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get colorIndigo;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorLightBlue.
  ///
  /// In en, this message translates to:
  /// **'Light Blue'**
  String get colorLightBlue;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get colorGrey;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// No description provided for @orMorePerDay.
  ///
  /// In en, this message translates to:
  /// **'or more per day'**
  String get orMorePerDay;

  /// No description provided for @colorBlueGrey.
  ///
  /// In en, this message translates to:
  /// **'Blue Grey'**
  String get colorBlueGrey;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Select Days'**
  String get selectDays;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get everyday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @selectTimes.
  ///
  /// In en, this message translates to:
  /// **'Select Times'**
  String get selectTimes;

  /// No description provided for @selectFrequency.
  ///
  /// In en, this message translates to:
  /// **'Select Frequency'**
  String get selectFrequency;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi ,'**
  String get hi;

  /// No description provided for @selectIconTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIconTitle;

  /// No description provided for @tabPreset.
  ///
  /// In en, this message translates to:
  /// **'Preset'**
  String get tabPreset;

  /// No description provided for @tabIcons.
  ///
  /// In en, this message translates to:
  /// **'Icons'**
  String get tabIcons;

  /// No description provided for @selectButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectButton;

  /// No description provided for @errorEitherIconOrHabitRequired.
  ///
  /// In en, this message translates to:
  /// **'Either an icon or a habit must be selected.'**
  String get errorEitherIconOrHabitRequired;

  /// No description provided for @selectColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColorTitle;

  /// No description provided for @colorPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get colorPreview;

  /// No description provided for @reminderWorkoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Remember to set off time for a workout today.'**
  String get reminderWorkoutMessage;

  /// No description provided for @letsMakeHabitsTogether.
  ///
  /// In en, this message translates to:
  /// **'Let’s make habits together!'**
  String get letsMakeHabitsTogether;

  /// No description provided for @handshakeEmoji.
  ///
  /// In en, this message translates to:
  /// **'👋🏻'**
  String get handshakeEmoji;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @clubs.
  ///
  /// In en, this message translates to:
  /// **'Clubs'**
  String get clubs;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @selectGoal.
  ///
  /// In en, this message translates to:
  /// **'Select Goal'**
  String get selectGoal;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get ml;

  /// No description provided for @drinkGoalPerDay.
  ///
  /// In en, this message translates to:
  /// **'Drink Goal per Day'**
  String get drinkGoalPerDay;

  /// No description provided for @walkingGoalPerDay.
  ///
  /// In en, this message translates to:
  /// **'Walking Goal per Day'**
  String get walkingGoalPerDay;

  /// No description provided for @durationGoalPerDay.
  ///
  /// In en, this message translates to:
  /// **'Duration Goal per Day'**
  String get durationGoalPerDay;

  /// No description provided for @readingGoalPerDay.
  ///
  /// In en, this message translates to:
  /// **'Reading Goal per Day'**
  String get readingGoalPerDay;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometers;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get meters;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @repetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get repetitions;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'Glasses'**
  String get glasses;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @calorieGoalPerDay.
  ///
  /// In en, this message translates to:
  /// **'calorie goal per day'**
  String get calorieGoalPerDay;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get weekdaySat;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @habits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habits;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noHabitsForDay.
  ///
  /// In en, this message translates to:
  /// **'No habits for this day'**
  String get noHabitsForDay;

  /// No description provided for @unnamedHabit.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Habit'**
  String get unnamedHabit;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get fail;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @habitCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Habit created successfully!'**
  String get habitCreatedSuccessfully;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @habitLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String habitLoadError(Object message);

  /// No description provided for @updateProgress.
  ///
  /// In en, this message translates to:
  /// **'Update Progress'**
  String get updateProgress;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @maxValueHelper.
  ///
  /// In en, this message translates to:
  /// **'Max: {max} {unit}'**
  String maxValueHelper(Object max, Object unit);

  /// No description provided for @dailyGoalsStart.
  ///
  /// In en, this message translates to:
  /// **'Your daily goals need a start'**
  String get dailyGoalsStart;

  /// No description provided for @dailyGoalsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Hurray! You have completed your goals'**
  String get dailyGoalsCompleted;

  /// No description provided for @dailyGoalsAlmostDone.
  ///
  /// In en, this message translates to:
  /// **'Your daily goals almost done!'**
  String get dailyGoalsAlmostDone;

  /// No description provided for @habitsCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} completed'**
  String habitsCompletedCount(Object completed, Object total);

  /// No description provided for @friendRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Friend removed successfully'**
  String get friendRemovedSuccess;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet.'**
  String get noFriendsYet;

  /// No description provided for @addFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriendTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get searchHint;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search for users to add as friends'**
  String get searchPrompt;

  /// No description provided for @friendAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Friend added successfully!'**
  String get friendAddedSuccess;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'member'**
  String get member;

  /// No description provided for @createClub.
  ///
  /// In en, this message translates to:
  /// **'Create Club'**
  String get createClub;

  /// No description provided for @allClubs.
  ///
  /// In en, this message translates to:
  /// **'All Clubs'**
  String get allClubs;

  /// No description provided for @myClubs.
  ///
  /// In en, this message translates to:
  /// **'My Clubs'**
  String get myClubs;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @habitClubs.
  ///
  /// In en, this message translates to:
  /// **'Habit Clubs'**
  String get habitClubs;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @suggestedForYou.
  ///
  /// In en, this message translates to:
  /// **'Suggested for You'**
  String get suggestedForYou;

  /// No description provided for @leaveClubTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Club'**
  String get leaveClubTitle;

  /// No description provided for @leaveClubMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this club?'**
  String get leaveClubMessage;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get noMessagesYet;

  /// No description provided for @typeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessageHint;

  /// No description provided for @clubMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Club Members'**
  String get clubMembersTitle;

  /// No description provided for @membersTab.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTab;

  /// No description provided for @requestsTab.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsTab;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'Members ({count})'**
  String membersCount(Object count);

  /// Message shown when there are no members in the list
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFound;

  /// Title for reject request dialog
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get rejectRequestTitle;

  /// Confirmation message for rejecting a join request
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject {userName}\'s request to join?'**
  String rejectRequestMessage(String userName);

  /// Reject button text
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Message shown when there are no pending join requests
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// Error message when requests cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Unable to load requests'**
  String get unableToLoadRequests;

  /// No description provided for @noClubsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No clubs available'**
  String get noClubsAvailable;

  /// No description provided for @createFirstClubMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first club to get started'**
  String get createFirstClubMessage;

  /// No description provided for @noClubsAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No clubs available yet'**
  String get noClubsAvailableYet;

  /// No description provided for @noMyClubsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined or created any clubs yet'**
  String get noMyClubsYet;

  /// No description provided for @whyDrinkWater.
  ///
  /// In en, this message translates to:
  /// **'Why should we drink water often?'**
  String get whyDrinkWater;

  /// No description provided for @benefitsOfWalking.
  ///
  /// In en, this message translates to:
  /// **'Benefits of regular walking'**
  String get benefitsOfWalking;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
