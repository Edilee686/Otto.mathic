import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../logic/generators.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';
import 'practice_screen.dart';
import 'trick_screens.dart';

/// Home: a short circus route. Every game is two taps away.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.current!;
    final l = AppLocalizations.of(context);
    final trick = p.trick(SkillId.trickX11.name);

    final ops = [
      (SkillId.add, l.addition, '+', Palette.mint),
      (SkillId.sub, l.subtraction, '−', Palette.coral),
      (SkillId.mul, l.multiplication, '×', Palette.violet),
      (SkillId.div, l.division, '÷', const Color(0xFF7FC8F8)),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Row(children: [
              BuddyAvatar(p.avatarId, size: 52),
              const Spacer(),
              CoinBadge(p.coins),
              IconButton(
                tooltip: l.switchPlayer,
                icon: const Icon(Icons.people_alt_rounded, size: 30),
                onPressed: state.signOut,
              ),
            ]),
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Otto(size: 110),
              const SizedBox(width: 8),
              Expanded(child: SpeechBubble(l.hello(p.name), size: 20)),
            ]),
            const SizedBox(height: 24),
            _SectionTitle(l.trickSchool, Icons.auto_awesome_rounded),
            _Tent(
              color: Palette.marigold,
              symbol: '×11',
              title: l.trickX11Title,
              subtitle: l.trickX11Tagline,
              stars: p.skill(SkillId.trickX11.name).bestStars,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const TrickDemoScreen())),
            ),
            const SizedBox(height: 24),
            _SectionTitle(l.jugglingPractice, Icons.sports_handball_rounded),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
              children: [
                for (final (id, name, sym, color) in ops)
                  _OpTent(
                    key: ValueKey('op-${id.name}'),
                    name: name,
                    symbol: sym,
                    color: color,
                    level: p.skill(id.name).level,
                    stars: p.skill(id.name).bestStars,
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PracticeScreen(skill: id))),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle(l.trickBook, Icons.menu_book_rounded),
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _TrickCard(unlocked: trick.unlocked, symbol: '×11', title: l.trickX11Title, lockedText: l.locked),
                  for (var i = 0; i < 5; i++)
                    _TrickCard(unlocked: false, symbol: '?', title: '', lockedText: l.locked),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, this.icon);
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon, color: Palette.marigold),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: rubik(22, weight: FontWeight.w700))),
        ]),
      );
}

class _Tent extends StatelessWidget {
  const _Tent({required this.color, required this.symbol, required this.title, required this.subtitle, required this.stars, required this.onTap});
  final Color color;
  final String symbol, title, subtitle;
  final int stars;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.cream,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        key: const ValueKey('trick-x11'),
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 76,
              height: 76,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
              child: Text(symbol, textDirection: TextDirection.ltr, style: rubik(28, weight: FontWeight.w800, color: Palette.ink)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: rubik(22, weight: FontWeight.w700, color: Palette.ink)),
                const SizedBox(height: 4),
                Text(subtitle, style: rubik(16, color: Palette.ink.withValues(alpha: 0.75))),
                const SizedBox(height: 6),
                StarRow(stars),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _OpTent extends StatelessWidget {
  const _OpTent({super.key, required this.name, required this.symbol, required this.color, required this.level, required this.stars, required this.onTap});
  final String name, symbol;
  final Color color;
  final int level, stars;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: Palette.cream,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Text(symbol, style: rubik(36, weight: FontWeight.w800, color: Palette.ink)),
            ),
            const SizedBox(height: 8),
            FittedBox(child: Text(name, style: rubik(19, weight: FontWeight.w700, color: Palette.ink))),
            Text(l.level(level), style: rubik(15, color: Palette.ink.withValues(alpha: 0.7))),
            StarRow(stars, size: 18),
          ]),
        ),
      ),
    );
  }
}

class _TrickCard extends StatelessWidget {
  const _TrickCard({required this.unlocked, required this.symbol, required this.title, required this.lockedText});
  final bool unlocked;
  final String symbol, title, lockedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsetsDirectional.only(end: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: unlocked ? Palette.violet : Palette.nightDeep,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: unlocked ? Palette.marigold : Palette.violet.withValues(alpha: 0.4), width: 3),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(unlocked ? Icons.auto_awesome_rounded : Icons.lock_rounded,
            color: unlocked ? Palette.marigold : Palette.violet),
        const SizedBox(height: 4),
        Text(symbol, textDirection: TextDirection.ltr, style: rubik(24, weight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(unlocked ? title : lockedText,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: rubik(12)),
      ]),
    );
  }
}
