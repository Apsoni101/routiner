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
  /// **'Profile'**
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
