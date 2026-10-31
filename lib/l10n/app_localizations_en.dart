// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Number Tricksters';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get whatsYourName => 'What\'s your name, young magician?';

  @override
  String get nameHint => 'Your name';

  @override
  String get pickBuddy => 'Pick your buddy';

  @override
  String get letsGo => 'Let\'s go!';

  @override
  String hello(String name) {
    return 'Hi, $name! Ready for some magic?';
  }

  @override
  String get whoIsPlaying => 'Who is playing today?';

  @override
  String get newPlayer => 'New player';

  @override
  String get switchPlayer => 'Switch player';

  @override
  String get trickSchool => 'Trick School';

  @override
  String get jugglingPractice => 'Juggling Practice';

  @override
  String get addition => 'Addition';

  @override
  String get subtraction => 'Subtraction';

  @override
  String get multiplication => 'Multiplication';

  @override
  String get division => 'Division';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String get trickX11Title => 'The ×11 Trick';

  @override
  String get trickX11Tagline => 'Multiply a two-digit number by 11 in a flash!';

  @override
  String trickIntro(int a) {
    return 'Watch me do $a × 11 faster than a calculator!';
  }

  @override
  String get trickStep1 => 'Pull the two digits apart and leave a gap.';

  @override
  String get trickStep2 => 'Add the two digits together.';

  @override
  String get trickStep3 => 'Put the sum in the gap. Abracadabra!';

  @override
  String get trickRule => 'Works when the two digits add up to 9 or less.';

  @override
  String get next => 'Next';

  @override
  String get tryIt => 'Try it!';

  @override
  String get watchAgain => 'Watch again';

  @override
  String get check => 'Check';

  @override
  String get hint => 'Hint';

  @override
  String get almost => 'Almost! Try again.';

  @override
  String get cheer1 => 'Magic!';

  @override
  String get cheer2 => 'Great!';

  @override
  String get cheer3 => 'Super!';

  @override
  String answerIs(int answer) {
    return 'The answer is $answer';
  }

  @override
  String get showsOver => 'Take a bow!';

  @override
  String youGot(int correct, int total) {
    return 'You got $correct of $total right';
  }

  @override
  String coinsEarned(int coins) {
    return 'Coins: +$coins';
  }

  @override
  String get levelUp => 'Level up! Next round gets a bit harder.';

  @override
  String get levelDown => 'Next round will be a little easier.';

  @override
  String get trickUnlocked => 'New trick card for your Trick Book!';

  @override
  String get trickNeedMore => 'Get 8 of 10 right to win the trick card.';

  @override
  String get again => 'Again';

  @override
  String get toMap => 'Back to the map';

  @override
  String get trickBook => 'Trick Book';

  @override
  String get locked => 'Not yet unlocked';

  @override
  String get language => 'Language';
}
