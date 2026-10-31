// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'קוסמי המספרים';

  @override
  String get chooseLanguage => 'בחרו שפה';

  @override
  String get whatsYourName => 'איך קוראים לך, קוסם צעיר?';

  @override
  String get nameHint => 'השם שלך';

  @override
  String get pickBuddy => 'בחרו חבר';

  @override
  String get letsGo => 'יוצאים לדרך!';

  @override
  String hello(String name) {
    return 'היי, $name! מוכנים לקסם?';
  }

  @override
  String get whoIsPlaying => 'מי משחק היום?';

  @override
  String get newPlayer => 'שחקן חדש';

  @override
  String get switchPlayer => 'החלפת שחקן';

  @override
  String get trickSchool => 'בית הספר לטריקים';

  @override
  String get jugglingPractice => 'תרגול ג\'אגלינג';

  @override
  String get addition => 'חיבור';

  @override
  String get subtraction => 'חיסור';

  @override
  String get multiplication => 'כפל';

  @override
  String get division => 'חילוק';

  @override
  String level(int level) {
    return 'שלב $level';
  }

  @override
  String get trickX11Title => 'טריק ה־11×';

  @override
  String get trickX11Tagline => 'כופלים מספר דו־ספרתי ב־11 בשנייה!';

  @override
  String trickIntro(int a) {
    return 'תראו איך אני פותר $a × 11 מהר יותר ממחשבון!';
  }

  @override
  String get trickStep1 => 'מפרידים את שתי הספרות ומשאירים רווח.';

  @override
  String get trickStep2 => 'מחברים את שתי הספרות.';

  @override
  String get trickStep3 => 'שמים את הסכום ברווח. אברקדברה!';

  @override
  String get trickRule => 'עובד כשסכום שתי הספרות הוא 9 או פחות.';

  @override
  String get next => 'הבא';

  @override
  String get tryIt => 'נסו בעצמכם!';

  @override
  String get watchAgain => 'צפייה חוזרת';

  @override
  String get check => 'בדיקה';

  @override
  String get hint => 'רמז';

  @override
  String get almost => 'כמעט! נסו שוב.';

  @override
  String get cheer1 => 'קסם!';

  @override
  String get cheer2 => 'מעולה!';

  @override
  String get cheer3 => 'סופר!';

  @override
  String answerIs(int answer) {
    return 'התשובה היא $answer';
  }

  @override
  String get showsOver => 'קידה לקהל!';

  @override
  String youGot(int correct, int total) {
    return 'צדקת ב־$correct מתוך $total';
  }

  @override
  String coinsEarned(int coins) {
    return 'מטבעות: +$coins';
  }

  @override
  String get levelUp => 'עלית שלב! הסיבוב הבא קצת יותר קשה.';

  @override
  String get levelDown => 'הסיבוב הבא יהיה קצת יותר קל.';

  @override
  String get trickUnlocked => 'כרטיס טריק חדש לספר הטריקים!';

  @override
  String get trickNeedMore => 'צריך 8 מתוך 10 כדי לזכות בכרטיס הטריק.';

  @override
  String get again => 'שוב';

  @override
  String get toMap => 'חזרה למפה';

  @override
  String get trickBook => 'ספר הטריקים';

  @override
  String get locked => 'עוד לא נפתח';

  @override
  String get language => 'שפה';
}
