import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../logic/generators.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';
import 'juggler_screen.dart';
import 'mind_magic_screens.dart';
import 'practice_screen.dart';
import 'results_screen.dart' show TrickCardTile;
import 'trick_screens.dart';

/// Home: Otto's greeting, then Trick School, Magic Show, Circus Games and
/// Juggling Practice. Every game is two taps away.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.current!;
    final l = AppLocalizations.of(context);
    void open(Widget screen) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

    final ops = [
      (SkillId.add, l.addition, '+', Palette.mint),
      (SkillId.sub, l.subtraction, '−', Palette.coral),
      (SkillId.mul, l.multiplication, '×', Palette.violet),
      (SkillId.div, l.division, '÷', Palette.sky),
    ];
    final cards = [
      for (final t in tricks) (t.symbol, t.title(l), p.trick(t.skill.name).unlocked),
      ('?', l.mindTitle, p.trick(mindAlways5Card).unlocked),
    ];

    return AppScaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Row(children: [
              BuddyAvatar(p.avatarId, size: 50),
              const SizedBox(width: 10),
              Expanded(
                child: Text(p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rubik(20, weight: FontWeight.w700)),
              ),
              CoinBadge(p.coins),
              IconButton(
                tooltip: l.switchPlayer,
                icon: const Icon(Icons.people_alt_rounded, size: 28, color: Palette.inkSoft),
                onPressed: state.signOut,
              ),
            ]),
            const SizedBox(height: 12),
            // Hero card: Otto says hello.
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [Color(0xFF9B82FF), Palette.violet],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: softShadow,
              ),
              child: Row(children: [
                const Otto(size: 100),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l.hello(p.name),
                      style: rubik(21, weight: FontWeight.w700, color: Colors.white, height: 1.3)),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            SectionTitle(l.trickSchool, Icons.auto_awesome_rounded),
            for (final t in tricks)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _WideTile(
                  key: ValueKey('trick-${t.skill.name}'),
                  symbol: t.symbol,
                  color: t.color,
                  title: t.title(l),
                  subtitle: t.tagline(l),
                  stars: p.skill(t.skill.name).bestStars,
                  onTap: () => open(TrickDemoScreen(trick: t)),
                ),
              ),
            const SizedBox(height: 12),
            SectionTitle(l.magicShow, Icons.psychology_alt_rounded, color: Palette.pink),
            _WideTile(
              key: const ValueKey('mind-magic'),
              symbol: '?',
              color: Palette.pink,
              title: l.mindTitle,
              subtitle: l.mindTagline,
              onTap: () => open(const MindMagicScreen()),
            ),
            const SizedBox(height: 24),
            SectionTitle(l.circusGames, Icons.celebration_rounded, color: Palette.sky),
            _WideTile(
              key: const ValueKey('juggler'),
              symbol: '10',
              color: Palette.sky,
              title: l.jugglerTitle,
              subtitle: l.jugglerTagline,
              stars: p.skill(SkillId.makeTen.name).bestStars,
              level: l.level(p.skill(SkillId.makeTen.name).level),
              onTap: () => open(const JugglerScreen()),
            ),
            const SizedBox(height: 24),
            SectionTitle(l.jugglingPractice, Icons.sports_handball_rounded, color: Palette.mint),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                for (final (id, name, sym, color) in ops)
                  SoftCard(
                    key: ValueKey('op-${id.name}'),
                    padding: const EdgeInsets.all(12),
                    onTap: () => open(PracticeScreen(skill: id)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SymbolTile(sym, color: color, size: 56),
                      const SizedBox(height: 8),
                      FittedBox(child: Text(name, style: rubik(18, weight: FontWeight.w700))),
                      const SizedBox(height: 2),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(l.level(p.skill(id.name).level),
                            style: rubik(13, color: Palette.inkSoft)),
                        const SizedBox(width: 6),
                        StarRow(p.skill(id.name).bestStars, size: 15),
                      ]),
                    ]),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SectionTitle(l.trickBook, Icons.menu_book_rounded, color: Palette.sun),
            SizedBox(
              height: 136,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  for (final (symbol, title, unlocked) in cards)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: TrickCardTile(symbol: symbol, title: unlocked ? title : l.locked, unlocked: unlocked),
                    ),
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: TrickCardTile(symbol: '?', title: l.locked, unlocked: false),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WideTile extends StatelessWidget {
  const _WideTile({super.key, required this.symbol, required this.color, required this.title, required this.subtitle, required this.onTap, this.stars, this.level});
  final String symbol, title, subtitle;
  final Color color;
  final int? stars;
  final String? level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      child: Row(children: [
        SymbolTile(symbol, color: color, size: 68),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: rubik(19, weight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(subtitle, style: rubik(14.5, color: Palette.inkSoft, height: 1.3)),
            if (stars != null || level != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                if (level != null) ...[
                  Text(level!, style: rubik(13, color: Palette.inkSoft)),
                  const SizedBox(width: 6),
                ],
                if (stars != null) StarRow(stars!, size: 16),
              ]),
            ],
          ]),
        ),
        Icon(Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded, color: Palette.inkSoft),
      ]),
    );
  }
}
