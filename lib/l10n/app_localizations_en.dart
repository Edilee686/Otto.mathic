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
  String trickIntro(String problem) {
    return 'Watch me do $problem faster than a calculator!';
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

  @override
  String get trickX5Title => 'The ×5 Trick';

  @override
  String get trickX5Tagline => 'Multiply by 10, then take half!';

  @override
  String get x5Step1 => 'First multiply by 10: just add a zero.';

  @override
  String get x5Step2 => 'Now take half.';

  @override
  String get x5Step3 => 'That\'s the answer. Abracadabra!';

  @override
  String get x5Rule => 'Easiest with even numbers.';

  @override
  String get magicShow => 'Magic Show';

  @override
  String get mindTitle => 'Otto Reads Minds';

  @override
  String get mindTagline => 'Think of a number and Otto will guess the answer!';

  @override
  String get mindPrediction => 'I\'ve hidden my prediction under my hat!';

  @override
  String get mindThink =>
      'Think of a number from 1 to 20 and type it. I\'m covering my eyes!';

  @override
  String get mindDouble => 'Double your number. What do you get?';

  @override
  String mindAdd(int n) {
    return 'Add $n. What do you get?';
  }

  @override
  String get mindHalve => 'Now take half. What do you get?';

  @override
  String get mindSubtract =>
      'Take away the number you first thought of. What\'s left?';

  @override
  String mindReveal(int k) {
    return 'You got $k! Let\'s peek under the hat...';
  }

  @override
  String get mindRange => 'Pick a number from 1 to 20.';

  @override
  String get howItWorks => 'How does it work?';

  @override
  String get mindHow1 =>
      'Your secret number is a bag of balls. Doubling it makes two bags.';

  @override
  String mindHow2(int n) {
    return 'Adding $n puts $n loose balls next to the bags.';
  }

  @override
  String mindHow3(int k) {
    return 'Taking half leaves one bag and $k loose balls.';
  }

  @override
  String mindHow4(int k) {
    return 'Taking away your number removes the bag, so $k is always left, whatever you picked!';
  }

  @override
  String get performIt => 'Perform it for your family';

  @override
  String get showTime => 'Show Time!';

  @override
  String get showTimeIntro =>
      'Do the magic on your family! Read these lines out loud:';

  @override
  String get scriptThink => 'Think of a number.';

  @override
  String get scriptDouble => 'Double it.';

  @override
  String scriptAdd(int n) {
    return 'Add $n.';
  }

  @override
  String get scriptHalve => 'Take half.';

  @override
  String get scriptSubtract => 'Take away the number you started with.';

  @override
  String scriptReveal(int k) {
    return 'Your answer is $k!';
  }

  @override
  String get circusGames => 'Circus Games';

  @override
  String get jugglerTitle => 'Juggler\'s Balls';

  @override
  String get jugglerTagline => 'Find the ball that makes 10!';

  @override
  String jugglerAsk(int target) {
    return 'Which ball makes $target?';
  }

  @override
  String get done => 'Done';
}
