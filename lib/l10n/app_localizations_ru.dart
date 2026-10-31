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
  String trickIntro(String problem) {
    return 'Смотри, я посчитаю $problem быстрее калькулятора!';
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

  @override
  String get trickX5Title => 'Фокус «×5»';

  @override
  String get trickX5Tagline => 'Умножь на 10 и возьми половину!';

  @override
  String get x5Step1 => 'Сначала умножь на 10: просто допиши ноль.';

  @override
  String get x5Step2 => 'Теперь возьми половину.';

  @override
  String get x5Step3 => 'Это и есть ответ. Абракадабра!';

  @override
  String get x5Rule => 'Проще всего с чётными числами.';

  @override
  String get magicShow => 'Магическое шоу';

  @override
  String get mindTitle => 'Отто читает мысли';

  @override
  String get mindTagline => 'Задумай число, а Отто угадает ответ!';

  @override
  String get mindPrediction => 'Я спрятал свой ответ под шляпой!';

  @override
  String get mindThink =>
      'Задумай число от 1 до 20 и введи его. Я закрываю глаза!';

  @override
  String get mindDouble => 'Удвой своё число. Что получилось?';

  @override
  String mindAdd(int n) {
    return 'Прибавь $n. Что получилось?';
  }

  @override
  String get mindHalve => 'Теперь возьми половину. Что получилось?';

  @override
  String get mindSubtract => 'Отними задуманное число. Что осталось?';

  @override
  String mindReveal(int k) {
    return 'Получилось $k! Заглянем под шляпу...';
  }

  @override
  String get mindRange => 'Выбери число от 1 до 20.';

  @override
  String get howItWorks => 'Как это работает?';

  @override
  String get mindHow1 =>
      'Твоё тайное число — это мешок с шариками. Удвоение даёт два мешка.';

  @override
  String mindHow2(int n) {
    return 'Прибавляем $n: рядом с мешками появляются отдельные шарики, их $n.';
  }

  @override
  String mindHow3(int k) {
    return 'Половина — это один мешок и ещё $k в сторонке.';
  }

  @override
  String mindHow4(int k) {
    return 'Отнимаем задуманное число, и мешок исчезает. Всегда остаётся $k, какое бы число ни было задумано!';
  }

  @override
  String get performIt => 'Показать фокус семье';

  @override
  String get showTime => 'Время шоу!';

  @override
  String get showTimeIntro => 'Покажи фокус семье! Прочитай вслух:';

  @override
  String get scriptThink => 'Задумай число.';

  @override
  String get scriptDouble => 'Удвой его.';

  @override
  String scriptAdd(int n) {
    return 'Прибавь $n.';
  }

  @override
  String get scriptHalve => 'Возьми половину.';

  @override
  String get scriptSubtract => 'Отними задуманное число.';

  @override
  String scriptReveal(int k) {
    return 'Получилось $k!';
  }

  @override
  String get circusGames => 'Цирковые игры';

  @override
  String get jugglerTitle => 'Шарики жонглёра';

  @override
  String get jugglerTagline => 'Найди шарик, который дополняет до 10!';

  @override
  String jugglerAsk(int target) {
    return 'Какой шарик дополняет до $target?';
  }

  @override
  String get done => 'Готово';
}
