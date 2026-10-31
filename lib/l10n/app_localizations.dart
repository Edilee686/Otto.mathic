import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Number Tricksters'**
  String get appTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @whatsYourName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name, young magician?'**
  String get whatsYourName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @pickBuddy.
  ///
  /// In en, this message translates to:
  /// **'Pick your buddy'**
  String get pickBuddy;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get letsGo;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}! Ready for some magic?'**
  String hello(String name);

  /// No description provided for @whoIsPlaying.
  ///
  /// In en, this message translates to:
  /// **'Who is playing today?'**
  String get whoIsPlaying;

  /// No description provided for @newPlayer.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get newPlayer;

  /// No description provided for @switchPlayer.
  ///
  /// In en, this message translates to:
  /// **'Switch player'**
  String get switchPlayer;

  /// No description provided for @trickSchool.
  ///
  /// In en, this message translates to:
  /// **'Trick School'**
  String get trickSchool;

  /// No description provided for @jugglingPractice.
  ///
  /// In en, this message translates to:
  /// **'Juggling Practice'**
  String get jugglingPractice;

  /// No description provided for @addition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get addition;

  /// No description provided for @subtraction.
  ///
  /// In en, this message translates to:
  /// **'Subtraction'**
  String get subtraction;

  /// No description provided for @multiplication.
  ///
  /// In en, this message translates to:
  /// **'Multiplication'**
  String get multiplication;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String level(int level);

  /// No description provided for @trickX11Title.
  ///
  /// In en, this message translates to:
  /// **'The ×11 Trick'**
  String get trickX11Title;

  /// No description provided for @trickX11Tagline.
  ///
  /// In en, this message translates to:
  /// **'Multiply a two-digit number by 11 in a flash!'**
  String get trickX11Tagline;

  /// No description provided for @trickIntro.
  ///
  /// In en, this message translates to:
  /// **'Watch me do {problem} faster than a calculator!'**
  String trickIntro(String problem);

  /// No description provided for @trickStep1.
  ///
  /// In en, this message translates to:
  /// **'Pull the two digits apart and leave a gap.'**
  String get trickStep1;

  /// No description provided for @trickStep2.
  ///
  /// In en, this message translates to:
  /// **'Add the two digits together.'**
  String get trickStep2;

  /// No description provided for @trickStep3.
  ///
  /// In en, this message translates to:
  /// **'Put the sum in the gap. Abracadabra!'**
  String get trickStep3;

  /// No description provided for @trickRule.
  ///
  /// In en, this message translates to:
  /// **'Works when the two digits add up to 9 or less.'**
  String get trickRule;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @tryIt.
  ///
  /// In en, this message translates to:
  /// **'Try it!'**
  String get tryIt;

  /// No description provided for @watchAgain.
  ///
  /// In en, this message translates to:
  /// **'Watch again'**
  String get watchAgain;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// No description provided for @almost.
  ///
  /// In en, this message translates to:
  /// **'Almost! Try again.'**
  String get almost;

  /// No description provided for @cheer1.
  ///
  /// In en, this message translates to:
  /// **'Magic!'**
  String get cheer1;

  /// No description provided for @cheer2.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get cheer2;

  /// No description provided for @cheer3.
  ///
  /// In en, this message translates to:
  /// **'Super!'**
  String get cheer3;

  /// No description provided for @answerIs.
  ///
  /// In en, this message translates to:
  /// **'The answer is {answer}'**
  String answerIs(int answer);

  /// No description provided for @showsOver.
  ///
  /// In en, this message translates to:
  /// **'Take a bow!'**
  String get showsOver;

  /// No description provided for @youGot.
  ///
  /// In en, this message translates to:
  /// **'You got {correct} of {total} right'**
  String youGot(int correct, int total);

  /// No description provided for @coinsEarned.
  ///
  /// In en, this message translates to:
  /// **'Coins: +{coins}'**
  String coinsEarned(int coins);

  /// No description provided for @levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up! Next round gets a bit harder.'**
  String get levelUp;

  /// No description provided for @levelDown.
  ///
  /// In en, this message translates to:
  /// **'Next round will be a little easier.'**
  String get levelDown;

  /// No description provided for @trickUnlocked.
  ///
  /// In en, this message translates to:
  /// **'New trick card for your Trick Book!'**
  String get trickUnlocked;

  /// No description provided for @trickNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Get 8 of 10 right to win the trick card.'**
  String get trickNeedMore;

  /// No description provided for @again.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get again;

  /// No description provided for @toMap.
  ///
  /// In en, this message translates to:
  /// **'Back to the map'**
  String get toMap;

  /// No description provided for @trickBook.
  ///
  /// In en, this message translates to:
  /// **'Trick Book'**
  String get trickBook;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Not yet unlocked'**
  String get locked;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @trickX5Title.
  ///
  /// In en, this message translates to:
  /// **'The ×5 Trick'**
  String get trickX5Title;

  /// No description provided for @trickX5Tagline.
  ///
  /// In en, this message translates to:
  /// **'Multiply by 10, then take half!'**
  String get trickX5Tagline;

  /// No description provided for @x5Step1.
  ///
  /// In en, this message translates to:
  /// **'First multiply by 10: just add a zero.'**
  String get x5Step1;

  /// No description provided for @x5Step2.
  ///
  /// In en, this message translates to:
  /// **'Now take half.'**
  String get x5Step2;

  /// No description provided for @x5Step3.
  ///
  /// In en, this message translates to:
  /// **'That\'s the answer. Abracadabra!'**
  String get x5Step3;

  /// No description provided for @x5Rule.
  ///
  /// In en, this message translates to:
  /// **'Easiest with even numbers.'**
  String get x5Rule;

  /// No description provided for @magicShow.
  ///
  /// In en, this message translates to:
  /// **'Magic Show'**
  String get magicShow;

  /// No description provided for @mindTitle.
  ///
  /// In en, this message translates to:
  /// **'Otto Reads Minds'**
  String get mindTitle;

  /// No description provided for @mindTagline.
  ///
  /// In en, this message translates to:
  /// **'Think of a number and Otto will guess the answer!'**
  String get mindTagline;

  /// No description provided for @mindPrediction.
  ///
  /// In en, this message translates to:
  /// **'I\'ve hidden my prediction under my hat!'**
  String get mindPrediction;

  /// No description provided for @mindThink.
  ///
  /// In en, this message translates to:
  /// **'Think of a number from 1 to 20 and type it. I\'m covering my eyes!'**
  String get mindThink;

  /// No description provided for @mindDouble.
  ///
  /// In en, this message translates to:
  /// **'Double your number. What do you get?'**
  String get mindDouble;

  /// No description provided for @mindAdd.
  ///
  /// In en, this message translates to:
  /// **'Add {n}. What do you get?'**
  String mindAdd(int n);

  /// No description provided for @mindHalve.
  ///
  /// In en, this message translates to:
  /// **'Now take half. What do you get?'**
  String get mindHalve;

  /// No description provided for @mindSubtract.
  ///
  /// In en, this message translates to:
  /// **'Take away the number you first thought of. What\'s left?'**
  String get mindSubtract;

  /// No description provided for @mindReveal.
  ///
  /// In en, this message translates to:
  /// **'You got {k}! Let\'s peek under the hat...'**
  String mindReveal(int k);

  /// No description provided for @mindRange.
  ///
  /// In en, this message translates to:
  /// **'Pick a number from 1 to 20.'**
  String get mindRange;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get howItWorks;

  /// No description provided for @mindHow1.
  ///
  /// In en, this message translates to:
  /// **'Your secret number is a bag of balls. Doubling it makes two bags.'**
  String get mindHow1;

  /// No description provided for @mindHow2.
  ///
  /// In en, this message translates to:
  /// **'Adding {n} puts {n} loose balls next to the bags.'**
  String mindHow2(int n);

  /// No description provided for @mindHow3.
  ///
  /// In en, this message translates to:
  /// **'Taking half leaves one bag and {k} loose balls.'**
  String mindHow3(int k);

  /// No description provided for @mindHow4.
  ///
  /// In en, this message translates to:
  /// **'Taking away your number removes the bag, so {k} is always left, whatever you picked!'**
  String mindHow4(int k);

  /// No description provided for @performIt.
  ///
  /// In en, this message translates to:
  /// **'Perform it for your family'**
  String get performIt;

  /// No description provided for @showTime.
  ///
  /// In en, this message translates to:
  /// **'Show Time!'**
  String get showTime;

  /// No description provided for @showTimeIntro.
  ///
  /// In en, this message translates to:
  /// **'Do the magic on your family! Read these lines out loud:'**
  String get showTimeIntro;

  /// No description provided for @scriptThink.
  ///
  /// In en, this message translates to:
  /// **'Think of a number.'**
  String get scriptThink;

  /// No description provided for @scriptDouble.
  ///
  /// In en, this message translates to:
  /// **'Double it.'**
  String get scriptDouble;

  /// No description provided for @scriptAdd.
  ///
  /// In en, this message translates to:
  /// **'Add {n}.'**
  String scriptAdd(int n);

  /// No description provided for @scriptHalve.
  ///
  /// In en, this message translates to:
  /// **'Take half.'**
  String get scriptHalve;

  /// No description provided for @scriptSubtract.
  ///
  /// In en, this message translates to:
  /// **'Take away the number you started with.'**
  String get scriptSubtract;

  /// No description provided for @scriptReveal.
  ///
  /// In en, this message translates to:
  /// **'Your answer is {k}!'**
  String scriptReveal(int k);

  /// No description provided for @circusGames.
  ///
  /// In en, this message translates to:
  /// **'Circus Games'**
  String get circusGames;

  /// No description provided for @jugglerTitle.
  ///
  /// In en, this message translates to:
  /// **'Juggler\'s Balls'**
  String get jugglerTitle;

  /// No description provided for @jugglerTagline.
  ///
  /// In en, this message translates to:
  /// **'Find the ball that makes 10!'**
  String get jugglerTagline;

  /// No description provided for @jugglerAsk.
  ///
  /// In en, this message translates to:
  /// **'Which ball makes {target}?'**
  String jugglerAsk(int target);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;
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
      <String>['en', 'he', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
