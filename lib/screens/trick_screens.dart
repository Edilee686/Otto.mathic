import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/generators.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';
import 'practice_screen.dart';

/// A Trick School trick: a three-step demo by Otto, then practice.
class TrickDef {
  const TrickDef({
    required this.skill,
    required this.symbol,
    required this.color,
    required this.title,
    required this.tagline,
    required this.rule,
    required this.steps,
    required this.board,
  });

  final SkillId skill;
  final String symbol;
  final Color color;
  final String Function(AppLocalizations) title, tagline, rule;

  /// Otto's three explanation lines (after the intro line).
  final List<String> Function(AppLocalizations) steps;

  /// The board for step 0 (question) .. 3 (answer) with example [a].
  final Widget Function(int step, int a) board;

  int pickExample() => SkillGenerator.forSkill(skill, Random()).generate(1).a;
}

TextStyle get _big => rubik(54, weight: FontWeight.w800);
TextStyle get _gold => rubik(54, weight: FontWeight.w800, color: const Color(0xFFE59A0C));
TextStyle get _small => rubik(26, weight: FontWeight.w700, color: Palette.inkSoft);

final tricks = <TrickDef>[
  TrickDef(
    skill: SkillId.trickX11,
    symbol: '×11',
    color: Palette.sun,
    title: (l) => l.trickX11Title,
    tagline: (l) => l.trickX11Tagline,
    rule: (l) => l.trickRule,
    steps: (l) => [l.trickStep1, l.trickStep2, l.trickStep3],
    board: (step, a) {
      final tens = a ~/ 10, ones = a % 10, sum = tens + ones;
      return switch (step) {
        0 => Text('$a × 11 = ?', style: _big),
        1 => Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$tens', style: _big),
            Container(
              width: 52,
              height: 52,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.violet, width: 4),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            Text('$ones', style: _big),
          ]),
        2 => Text('$tens + $ones = $sum', style: _big),
        _ => Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text('$tens', style: _big),
              Text('$sum', style: _gold),
              Text('$ones', style: _big),
            ]),
            Text('$a × 11 = ${a * 11}', style: _small),
          ]),
      };
    },
  ),
  TrickDef(
    skill: SkillId.trickX5,
    symbol: '×5',
    color: Palette.mint,
    title: (l) => l.trickX5Title,
    tagline: (l) => l.trickX5Tagline,
    rule: (l) => l.x5Rule,
    steps: (l) => [l.x5Step1, l.x5Step2, l.x5Step3],
    board: (step, a) => switch (step) {
      0 => Text('$a × 5 = ?', style: _big),
      1 => Row(mainAxisSize: MainAxisSize.min, children: [
          Text('$a × 10 = $a', style: _big),
          Text('0', style: _gold),
        ]),
      2 => Text('${a * 10} ÷ 2 = ${a * 5}', style: _big),
      _ => Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${a * 5}', style: _gold),
          Text('$a × 5 = ${a * 5}', style: _small),
        ]),
    },
  ),
];

TrickDef trickFor(SkillId skill) => tricks.firstWhere((t) => t.skill == skill);

/// Trick School demo: Otto shows the trick in three steps, then the child
/// practises it (8 of 10 correct wins the trick card).
class TrickDemoScreen extends StatefulWidget {
  const TrickDemoScreen({super.key, required this.trick, this.example});
  final TrickDef trick;
  final int? example;

  @override
  State<TrickDemoScreen> createState() => _TrickDemoScreenState();
}

class _TrickDemoScreenState extends State<TrickDemoScreen> {
  late int _a = widget.example ?? widget.trick.pickExample();
  int _step = 0; // 0 intro, 1-3 steps

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = widget.trick;
    final problem = '$_a ${t.symbol.substring(0, 1)} ${t.symbol.substring(1)}';
    final texts = [l.trickIntro(problem), ...t.steps(l)];

    return AppScaffold(
      appBar: AppBar(title: Text(t.title(l), style: rubik(20, weight: FontWeight.w700))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Otto(size: 130, mood: _step == 3 ? OttoMood.cheering : OttoMood.happy),
                const SizedBox(height: 8),
                SpeechBubble(texts[_step]),
                const SizedBox(height: 20),
                SoftCard(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    width: double.infinity,
                    height: 170,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        transitionBuilder: (child, anim) => ScaleTransition(
                          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: Padding(
                          key: ValueKey(_step),
                          padding: const EdgeInsets.all(16),
                          child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: t.board(_step, _a))),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var i = 0; i < 4; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: i == _step ? 26 : 10,
                      height: 10,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: i <= _step ? Palette.violet : Palette.lilac,
                      ),
                    ),
                ]),
                const SizedBox(height: 10),
                Text(t.rule(l),
                    textAlign: TextAlign.center, style: rubik(15, color: Palette.inkSoft)),
                const SizedBox(height: 24),
                if (_step < 3)
                  FilledButton(
                    key: const ValueKey('trick-next'),
                    onPressed: () => setState(() => _step++),
                    child: Text(l.next),
                  )
                else
                  Wrap(spacing: 14, runSpacing: 12, alignment: WrapAlignment.center, children: [
                    OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _a = t.pickExample();
                        _step = 0;
                      }),
                      icon: const Icon(Icons.replay_rounded),
                      label: Text(l.watchAgain),
                    ),
                    FilledButton(
                      key: const ValueKey('trick-try'),
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => PracticeScreen(skill: t.skill))),
                      child: Text(l.tryIt),
                    ),
                  ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
