// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Числовые фокусники';

  @override
  String get chooseLanguage => 'Выбери язык';

  @override
  String get whatsYourName => 'Как тебя зовут, юный фокусник?';

  @override
  String get nameHint => 'Твоё имя';

  @override
  String get pickBuddy => 'Выбери друга';

  @override
  String get letsGo => 'Поехали!';

  @override
  String hello(String name) {
    return 'Привет, $name! Начнём фокусы?';
  }

  @override
  String get whoIsPlaying => 'Кто сегодня играет?';

  @override
  String get newPlayer => 'Новый игрок';

  @override
  String get switchPlayer => 'Сменить игрока';

  @override
  String get trickSchool => 'Школа фокусов';

  @override
  String get jugglingPractice => 'Жонглёрская тренировка';

  @override
  String get addition => 'Сложение';

  @override
  String get subtraction => 'Вычитание';

  @override
  String get multiplication => 'Умножение';

  @override
  String get division => 'Деление';

  @override
  String level(int level) {
    return 'Уровень $level';
  }

  @override
  String get trickX11Title => 'Фокус «×11»';

  @override
  String get trickX11Tagline =>
      'Умножай двузначное число на 11 в одно мгновение!';

  @override
  String trickIntro(int a) {
    return 'Смотри, я посчитаю $a × 11 быстрее калькулятора!';
  }

  @override
  String get trickStep1 => 'Раздвинь две цифры и оставь между ними место.';

  @override
  String get trickStep2 => 'Сложи эти две цифры.';

  @override
  String get trickStep3 => 'Поставь сумму в середину. Абракадабра!';

  @override
  String get trickRule => 'Работает, когда сумма цифр не больше 9.';

  @override
  String get next => 'Дальше';

  @override
  String get tryIt => 'Попробуй!';

  @override
  String get watchAgain => 'Ещё раз';

  @override
  String get check => 'Проверить';

  @override
  String get hint => 'Подсказка';

  @override
  String get almost => 'Почти! Попробуй ещё.';

  @override
  String get cheer1 => 'Волшебно!';

  @override
  String get cheer2 => 'Отлично!';

  @override
  String get cheer3 => 'Супер!';

  @override
  String answerIs(int answer) {
    return 'Ответ: $answer';
  }

  @override
  String get showsOver => 'Поклон публике!';

  @override
  String youGot(int correct, int total) {
    return 'Верно: $correct из $total';
  }

  @override
  String coinsEarned(int coins) {
    return 'Монеты: +$coins';
  }

  @override
  String get levelUp => 'Новый уровень! Дальше будет чуть сложнее.';

  @override
  String get levelDown => 'Следующий раунд будет чуть легче.';

  @override
  String get trickUnlocked => 'Новая карта фокуса в твоей Книге фокусов!';

  @override
  String get trickNeedMore => 'Реши 8 из 10, чтобы получить карту фокуса.';

  @override
  String get again => 'Ещё раз';

  @override
  String get toMap => 'На карту';

  @override
  String get trickBook => 'Книга фокусов';

  @override
  String get locked => 'Пока закрыто';

  @override
  String get language => 'Язык';
}
