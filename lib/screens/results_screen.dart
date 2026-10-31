import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';

/// End of a round: stars, coins, level change and any new trick card.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.outcome, required this.onAgain, this.newCard});
  final RoundOutcome outcome;
  final VoidCallback onAgain;

  /// Trick Book card won this round (symbol + title), if any.
  final (String, String)? newCard;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lines = <String>[
      l.youGot(outcome.correct, outcome.total),
      l.coinsEarned(outcome.coins),
      if (outcome.levelDelta > 0) l.levelUp,
      if (outcome.levelDelta < 0) l.levelDown,
      if (outcome.isTrick && !outcome.trickUnlocked && outcome.correct < trickUnlockScore) l.trickNeedMore,
      if (outcome.trickUnlocked) l.trickUnlocked,
    ];

    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Otto(size: 150, balls: outcome.stars * 2, mood: OttoMood.cheering),
                Text(l.showsOver, style: rubik(32, weight: FontWeight.w800)),
                const SizedBox(height: 10),
                StarRow(outcome.stars, size: 60),
                const SizedBox(height: 16),
                SoftCard(
                  child: Column(children: [
                    for (final line in lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(line,
                            textAlign: TextAlign.center,
                            style: rubik(19, weight: FontWeight.w600, height: 1.3)),
                      ),
                  ]),
                ),
                if (newCard != null) ...[
                  const SizedBox(height: 16),
                  TrickCardTile(symbol: newCard!.$1, title: newCard!.$2, unlocked: true, big: true),
                ],
                const SizedBox(height: 28),
                Wrap(spacing: 14, runSpacing: 12, alignment: WrapAlignment.center, children: [
                  OutlinedButton(onPressed: onAgain, child: Text(l.again)),
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
      ),
    );
  }
}

const int trickUnlockScore = 8;

/// A Trick Book card.
class TrickCardTile extends StatelessWidget {
  const TrickCardTile({super.key, required this.symbol, required this.title, required this.unlocked, this.big = false});
  final String symbol, title;
  final bool unlocked, big;

  @override
  Widget build(BuildContext context) {
    final w = big ? 160.0 : 104.0;
    return Container(
      width: w,
      height: big ? 180 : 128,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: unlocked
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9B82FF), Palette.violet])
            : null,
        color: unlocked ? null : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(22),
        boxShadow: unlocked ? softShadow : null,
        border: unlocked ? null : Border.all(color: Palette.lilac, width: 2),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(unlocked ? Icons.auto_awesome_rounded : Icons.lock_rounded,
            color: unlocked ? Palette.sun : Palette.lilac, size: big ? 32 : 22),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(symbol,
              textDirection: TextDirection.ltr,
              style: rubik(big ? 40 : 26, weight: FontWeight.w800, color: unlocked ? Colors.white : Palette.inkSoft.withValues(alpha: 0.5))),
        ),
        const SizedBox(height: 2),
        Text(title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: rubik(big ? 15 : 12, weight: FontWeight.w600, color: unlocked ? Colors.white : Palette.inkSoft)),
      ]),
    );
  }
}
