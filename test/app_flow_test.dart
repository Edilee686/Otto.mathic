import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_tricksters/data/app_state.dart';
import 'package:number_tricksters/widgets/common.dart';
import 'package:number_tricksters/logic/generators.dart';
import 'package:number_tricksters/logic/mind_magic.dart';
import 'package:number_tricksters/screens/mind_magic_screens.dart';
import 'package:number_tricksters/screens/juggler_screen.dart';
import 'package:number_tricksters/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(NumberTrickstersApp(state: AppState(prefs)));
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> settle(WidgetTester tester) async {
  // Otto animates forever, so pump fixed frames instead of pumpAndSettle.
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('first launch: Hebrew, name, then greeted in RTL; remembered on restart',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await pumpApp(tester);
    expect(find.text('עברית'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lang-he')));
    await settle(tester);

    expect(find.text('איך קוראים לך, קוסם צעיר?'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('name-field')), 'נועה');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('lets-go')));
    await settle(tester);

    expect(find.text('היי, נועה! מוכנים לקסם?'), findsOneWidget);
    final dir = Directionality.of(tester.element(find.text('בית הספר לטריקים')));
    expect(dir, TextDirection.rtl);

    // Restart: a fresh AppState reads the saved profile.
    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester);
    expect(find.text('היי, נועה! מוכנים לקסם?'), findsOneWidget);
  });

  testWidgets('a full round of 10 problems ends on the results screen', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    final prefs = await SharedPreferences.getInstance();
    final state = AppState(prefs)..chooseLanguage('en');
    await state.createProfile('Sam', 1);
    await tester.pumpWidget(NumberTrickstersApp(state: state));
    await settle(tester);

    await tester.scrollUntilVisible(find.byKey(const ValueKey('op-add')), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(const ValueKey('op-add')));
    await settle(tester);

    for (var i = 0; i < 10; i++) {
      final q = (tester.widget<Text>(find.byKey(const ValueKey('question'))).data!)
          .replaceAll(' = ', '')
          .split(' + ');
      final answer = int.parse(q[0]) + int.parse(q[1]);
      for (final ch in '$answer'.split('')) {
        await tester.tap(find.text(ch).last);
        await tester.pump();
      }
      await tester.tap(find.text('Check'));
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await settle(tester);
    expect(find.text('Take a bow!'), findsOneWidget);
    expect(find.text('You got 10 of 10 right'), findsOneWidget);
    expect(state.current!.coins, 10);
    expect(state.current!.skill(SkillId.add.name).bestStars, 3);
    expect(state.current!.skill(SkillId.add.name).level, 2, reason: '100% steps up');
  });

  Future<AppState> signedIn(WidgetTester tester, Widget? start) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final prefs = await SharedPreferences.getInstance();
    final state = AppState(prefs)..chooseLanguage('en');
    await state.createProfile('Sam', 1);
    await tester.pumpWidget(NumberTrickstersApp(state: state));
    await settle(tester);
    if (start != null) {
      Navigator.of(tester.element(find.byType(Scaffold).first))
          .push(MaterialPageRoute(builder: (_) => start));
      await settle(tester);
    }
    return state;
  }

  Future<void> typeNumber(WidgetTester tester, int n) async {
    for (final ch in '$n'.split('')) {
      await tester.tap(find.bySemanticsLabel(ch).last);
      await tester.pump();
    }
    await tester.tap(find.bySemanticsLabel('Check'));
    await settle(tester);
  }

  testWidgets('Otto reads minds: every step checked, prediction revealed, card unlocked',
      (tester) async {
    final state = await signedIn(tester, MindMagicScreen(magic: MindMagic(5)));
    await tester.tap(find.byKey(const ValueKey('mind-start')));
    await settle(tester);
    await typeNumber(tester, 25); // out of range: stays on the same step
    expect(find.text('Pick a number from 1 to 20.'), findsOneWidget);
    await typeNumber(tester, 7);
    expect(find.text('Double your number. What do you get?'), findsOneWidget);
    await typeNumber(tester, 13); // wrong once: hint
    expect(find.text('7 + 7'), findsOneWidget);
    await typeNumber(tester, 14);
    await typeNumber(tester, 24);
    await typeNumber(tester, 12);
    await typeNumber(tester, 5);
    expect(find.byKey(const ValueKey('prediction')), findsOneWidget);
    expect(find.text('You got 5! Let\'s peek under the hat...'), findsOneWidget);
    expect(state.current!.trick(mindAlways5Card).unlocked, isTrue);

    await tester.tap(find.byKey(const ValueKey('mind-perform')));
    await settle(tester);
    expect(find.text('Add 10.'), findsOneWidget);
    expect(find.text('Your answer is 5!'), findsOneWidget);
  });

  testWidgets("Juggler's Balls: a perfect round of 10 levels up", (tester) async {
    final state = await signedIn(tester, const JugglerScreen());
    for (var i = 0; i < 10; i++) {
      final row = tester.widget<Text>(find.byKey(const ValueKey('juggler-question'))).data!;
      final target = int.parse(row.replaceAll('=', '').trim());
      // The held ball is the first number in the equation card.
      final held = tester
          .widgetList<Text>(find.descendant(of: find.byType(Wobble), matching: find.byType(Text)))
          .map((t) => int.tryParse(t.data ?? ''))
          .whereType<int>()
          .first;
      await tester.tap(find.byKey(ValueKey('choice-${target - held}')));
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await settle(tester);
    expect(find.text('You got 10 of 10 right'), findsOneWidget);
    expect(state.current!.skill(SkillId.makeTen.name).level, 2);
  });
}
