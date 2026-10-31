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
  String trickIntro(String problem) {
    return 'תראו איך אני פותר $problem מהר יותר ממחשבון!';
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

  @override
  String get trickX5Title => 'טריק ה־5×';

  @override
  String get trickX5Tagline => 'כופלים ב־10 ולוקחים חצי!';

  @override
  String get x5Step1 => 'קודם כופלים ב־10: פשוט מוסיפים אפס.';

  @override
  String get x5Step2 => 'עכשיו לוקחים חצי.';

  @override
  String get x5Step3 => 'זו התשובה. אברקדברה!';

  @override
  String get x5Rule => 'הכי קל עם מספרים זוגיים.';

  @override
  String get magicShow => 'מופע קסמים';

  @override
  String get mindTitle => 'אוטו קורא מחשבות';

  @override
  String get mindTagline => 'חשבו על מספר, ואוטו ינחש את התשובה!';

  @override
  String get mindPrediction => 'החבאתי את הניחוש שלי מתחת לכובע!';

  @override
  String get mindThink =>
      'חשבו על מספר מ־1 עד 20 והקלידו אותו. אני עוצם עיניים!';

  @override
  String get mindDouble => 'הכפילו את המספר שלכם. כמה יצא?';

  @override
  String mindAdd(int n) {
    return 'הוסיפו $n. כמה יצא?';
  }

  @override
  String get mindHalve => 'עכשיו קחו חצי. כמה יצא?';

  @override
  String get mindSubtract => 'הורידו את המספר שחשבתם עליו בהתחלה. כמה נשאר?';

  @override
  String mindReveal(int k) {
    return 'יצא לכם $k! בואו נציץ מתחת לכובע...';
  }

  @override
  String get mindRange => 'בחרו מספר מ־1 עד 20.';

  @override
  String get howItWorks => 'איך זה עובד?';

  @override
  String get mindHow1 =>
      'המספר הסודי שלכם הוא שקית כדורים. הכפלה יוצרת שתי שקיות.';

  @override
  String mindHow2(int n) {
    return 'הוספת $n שמה ליד השקיות $n כדורים בודדים.';
  }

  @override
  String mindHow3(int k) {
    return 'לקיחת חצי משאירה שקית אחת ו־$k כדורים בודדים.';
  }

  @override
  String mindHow4(int k) {
    return 'הורדת המספר שלכם מעלימה את השקית, אז תמיד נשאר $k, לא משנה מה בחרתם!';
  }

  @override
  String get performIt => 'להופיע מול המשפחה';

  @override
  String get showTime => 'זמן הופעה!';

  @override
  String get showTimeIntro => 'עשו את הקסם על המשפחה! הקריאו את השורות בקול:';

  @override
  String get scriptThink => 'חשבו על מספר.';

  @override
  String get scriptDouble => 'הכפילו אותו.';

  @override
  String scriptAdd(int n) {
    return 'הוסיפו $n.';
  }

  @override
  String get scriptHalve => 'קחו חצי.';

  @override
  String get scriptSubtract => 'הורידו את המספר שהתחלתם איתו.';

  @override
  String scriptReveal(int k) {
    return 'יצא לכם $k!';
  }

  @override
  String get circusGames => 'משחקי קרקס';

  @override
  String get jugglerTitle => 'כדורי הלהטוטן';

  @override
  String get jugglerTagline => 'מצאו את הכדור שמשלים ל־10!';

  @override
  String jugglerAsk(int target) {
    return 'איזה כדור משלים ל־$target?';
  }

  @override
  String get done => 'סיום';
}
