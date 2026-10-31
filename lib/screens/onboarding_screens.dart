import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';

const _languageNames = {'en': 'English', 'he': 'עברית', 'ru': 'Русский'};
const _languageHints = {'en': 'EN', 'he': 'HE', 'ru': 'RU'};

/// Screen 2a: three big language buttons. The heading shows in all three
/// languages because the child has not picked one yet.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (state.onboarding)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      icon: const Icon(Icons.close_rounded, size: 30),
                      onPressed: state.cancelNewPlayer,
                    ),
                  ),
                const Otto(size: 170),
                const SizedBox(height: 8),
                Text(lookupAppLocalizations(const Locale('en')).appTitle,
                    style: rubik(30, weight: FontWeight.w800, color: Palette.violetDeep)),
                const SizedBox(height: 6),
                for (final l in supportedLanguages)
                  Text(lookupAppLocalizations(Locale(l)).chooseLanguage,
                      textAlign: TextAlign.center,
                      style: rubik(17, color: Palette.inkSoft, height: 1.4)),
                const SizedBox(height: 24),
                for (final lang in supportedLanguages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SoftCard(
                      key: ValueKey('lang-$lang'),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      onTap: () {
                        state.chooseLanguage(lang);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NameScreen()));
                      },
                      child: Semantics(
                        button: true,
                        label: _languageNames[lang],
                        excludeSemantics: true,
                        child: Row(children: [
                          SymbolTile(_languageHints[lang]!, color: Palette.violet, size: 48),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(_languageNames[lang]!,
                                style: rubik(24, weight: FontWeight.w700)),
                          ),
                          Icon(Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded, color: Palette.inkSoft),
                        ]),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen 2b: the child's name (first name or nickname only) and a buddy.
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _name = TextEditingController();
  int _buddy = 0;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    final nav = Navigator.of(context);
    await AppScope.of(context).createProfile(_name.text, _buddy);
    nav.popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ok = _name.text.trim().isNotEmpty;
    return AppScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Otto(size: 120),
                const SizedBox(height: 8),
                SpeechBubble(l.whatsYourName),
                const SizedBox(height: 20),
                TextField(
                  key: const ValueKey('name-field'),
                  controller: _name,
                  maxLength: 16,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  style: rubik(26, weight: FontWeight.w600),
                  decoration: InputDecoration(hintText: l.nameHint, counterText: ''),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => ok ? _go() : null,
                ),
                const SizedBox(height: 24),
                Text(l.pickBuddy, style: rubik(18, weight: FontWeight.w600, color: Palette.inkSoft)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var i = 0; i < buddies.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => _buddy = i),
                        child: BuddyAvatar(i, size: 68, selected: i == _buddy),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                FilledButton(
                  key: const ValueKey('lets-go'),
                  onPressed: ok ? _go : null,
                  child: Text(l.letsGo),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Later launches: choose who is playing (up to 4 profiles).
class ProfilePickerScreen extends StatelessWidget {
  const ProfilePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    // Picker text follows the most recently created profile's language.
    final l = lookupAppLocalizations(state.profiles.last.locale);
    Widget tile(Widget avatar, String name, VoidCallback onTap) => SizedBox(
          width: 140,
          child: SoftCard(
            onTap: onTap,
            child: Column(children: [
              avatar,
              const SizedBox(height: 10),
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: rubik(19, weight: FontWeight.w700)),
            ]),
          ),
        );
    return Directionality(
      textDirection: state.profiles.last.language == 'he' ? TextDirection.rtl : TextDirection.ltr,
      child: AppScaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Otto(size: 140),
                const SizedBox(height: 12),
                Text(l.whoIsPlaying, style: rubik(26, weight: FontWeight.w800)),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final p in state.profiles)
                      tile(BuddyAvatar(p.avatarId, size: 76), p.name, () => state.selectProfile(p)),
                    if (state.canAddProfile)
                      tile(
                        Container(
                          width: 76,
                          height: 76,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Palette.lilac),
                          child: const Icon(Icons.add_rounded, size: 40, color: Palette.violet),
                        ),
                        l.newPlayer,
                        state.startNewPlayer,
                      ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
