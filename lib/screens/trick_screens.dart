import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/generators.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';
import 'practice_screen.dart';

/// Trick School demo for the ×11 trick: Otto shows it in three steps,
/// then the child practises it (8 of 10 correct wins the trick card).
class TrickDemoScreen extends StatefulWidget {
  const TrickDemoScreen({super.key, this.example});
  final int? example;

  @override
  State<TrickDemoScreen> createState() => _TrickDemoScreenState();
}

class _TrickDemoScreenState extends State<TrickDemoScreen> {
  late int _a = widget.example ?? _pick();
  int _step = 0; // 0 intro, 1 split, 2 add, 3 reveal

  int _pick() => TimesElevenGenerator(Random()).generate(1).a;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tens = _a ~/ 10, ones = _a % 10, sum = tens + ones;
    final texts = [l.trickIntro(_a), l.trickStep1, l.trickStep2, l.trickStep3];

    final big = rubik(56, weight: FontWeight.w800, color: Palette.ink);
    final gold = rubik(56, weight: FontWeight.w800, color: const Color(0xFFD9901A));
    final Widget board = switch (_step) {
      0 => Text('$_a × 11 = ?', style: big),
      1 => Row(mainAxisSize: MainAxisSize.min, children: [
          Text('$tens', style: big),
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.violet, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Text('$ones', style: big),
        ]),
      2 => Text('$tens + $ones = $sum', style: big),
      _ => Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$tens', style: big),
            Text('$sum', style: gold),
            Text('$ones', style: big),
          ]),
          Text('$_a × 11 = ${_a * 11}', style: rubik(28, weight: FontWeight.w700, color: Palette.ink)),
        ]),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l.trickX11Title, style: rubik(22, weight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Otto(size: 140, mood: _step == 3 ? OttoMood.cheering : OttoMood.happy),
                const SizedBox(height: 8),
                SpeechBubble(texts[_step]),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Palette.cream,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: FittedBox(key: ValueKey(_step), fit: BoxFit.scaleDown, child: board),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Dots show which step we are on.
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var i = 0; i < 4; i++)
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= _step ? Palette.marigold : Palette.nightDeep,
                      ),
                    ),
                ]),
                const SizedBox(height: 8),
                Text(l.trickRule,
                    textAlign: TextAlign.center,
                    style: rubik(16, color: Palette.cream.withValues(alpha: 0.75))),
                const SizedBox(height: 24),
                if (_step < 3)
                  FilledButton(
                    key: const ValueKey('trick-next'),
                    onPressed: () => setState(() => _step++),
                    child: Text(l.next),
                  )
                else
                  Wrap(spacing: 16, runSpacing: 12, alignment: WrapAlignment.center, children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(140, 64),
                        foregroundColor: Palette.cream,
                        side: const BorderSide(color: Palette.cream, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      ),
                      onPressed: () => setState(() {
                        _a = _pick();
                        _step = 0;
                      }),
                      icon: const Icon(Icons.replay_rounded, color: Palette.cream),
                      label: Text(l.watchAgain, style: rubik(20, weight: FontWeight.w700, color: Palette.cream)),
                    ),
                    FilledButton(
                      key: const ValueKey('trick-try'),
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const PracticeScreen(skill: SkillId.trickX11))),
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
