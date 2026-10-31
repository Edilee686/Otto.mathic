import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../logic/generators.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';
import 'practice_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.skill, required this.outcome});
  final SkillId skill;
  final RoundOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lines = <String>[
      l.youGot(outcome.correct, outcome.total),
      l.coinsEarned(outcome.coins),
      if (outcome.levelDelta > 0) l.levelUp,
      if (outcome.levelDelta < 0) l.levelDown,
      if (outcome.isTrick) outcome.trickUnlocked ? l.trickUnlocked : (outcome.correct >= 8 ? '' : l.trickNeedMore),
    ]..removeWhere((s) => s.isEmpty);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Otto(size: 160, balls: outcome.stars * 2, mood: OttoMood.cheering),
              Text(l.showsOver, style: rubik(34, weight: FontWeight.w800)),
              const SizedBox(height: 12),
              StarRow(outcome.stars, size: 64),
              const SizedBox(height: 16),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(line,
                      textAlign: TextAlign.center, style: rubik(22, weight: FontWeight.w600)),
                ),
              if (outcome.trickUnlocked)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: BoxDecoration(
                    color: Palette.violet,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Palette.marigold, width: 4),
                  ),
                  child: Column(children: [
                    const Icon(Icons.auto_awesome_rounded, color: Palette.marigold, size: 36),
                    Text('×11', textDirection: TextDirection.ltr, style: rubik(40, weight: FontWeight.w800)),
                    Text(l.trickX11Title, style: rubik(18, weight: FontWeight.w600)),
                  ]),
                ),
              const SizedBox(height: 28),
              Wrap(spacing: 16, runSpacing: 12, alignment: WrapAlignment.center, children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(140, 64),
                    foregroundColor: Palette.cream,
                        side: const BorderSide(color: Palette.cream, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => PracticeScreen(skill: skill))),
                  child: Text(l.again, style: rubik(22, weight: FontWeight.w700, color: Palette.cream)),
                ),
                FilledButton(
                  key: const ValueKey('to-map'),
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: Text(l.toMap),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
