import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_tricksters/data/app_state.dart';
import 'package:number_tricksters/logic/generators.dart';
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
}
