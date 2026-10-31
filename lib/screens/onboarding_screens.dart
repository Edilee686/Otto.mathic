import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';

const _languageNames = {'en': 'English', 'he': 'עברית', 'ru': 'Русский'};

/// Screen 2a: three big language buttons. The heading shows in all three
/// languages because the child has not picked one yet.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final headings = supportedLanguages
        .map((l) => lookupAppLocalizations(Locale(l)).chooseLanguage)
        .join('  ·  ');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (state.onboarding)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 32),
                    onPressed: state.cancelNewPlayer,
                  ),
                ),
              const Otto(size: 170),
              const SizedBox(height: 16),
              Text(headings,
                  textAlign: TextAlign.center, style: rubik(20, weight: FontWeight.w600)),
              const SizedBox(height: 28),
              for (final lang in supportedLanguages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: 300,
                    child: FilledButton(
                      key: ValueKey('lang-$lang'),
                      onPressed: () {
                        state.chooseLanguage(lang);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NameScreen()));
                      },
                      child: Text(_languageNames[lang]!),
                    ),
                  ),
                ),
            ]),
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
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
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
                  style: rubik(28, weight: FontWeight.w600, color: Palette.ink),
                  decoration: InputDecoration(hintText: l.nameHint, counterText: ''),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => ok ? _go() : null,
                ),
                const SizedBox(height: 24),
                Text(l.pickBuddy, style: rubik(20, weight: FontWeight.w600)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var i = 0; i < buddies.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => _buddy = i),
                        child: BuddyAvatar(i, size: 72, selected: i == _buddy),
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
    return Directionality(
      textDirection: state.profiles.last.language == 'he' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Otto(size: 140),
                const SizedBox(height: 12),
                Text(l.whoIsPlaying, style: rubik(26, weight: FontWeight.w700)),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final p in state.profiles)
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => state.selectProfile(p),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(children: [
                            BuddyAvatar(p.avatarId, size: 88),
                            const SizedBox(height: 8),
                            Text(p.name, style: rubik(22, weight: FontWeight.w600)),
                          ]),
                        ),
                      ),
                    if (state.canAddProfile)
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: state.startNewPlayer,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Palette.cream, width: 3)),
                              child: const Icon(Icons.add_rounded, size: 48),
                            ),
                            const SizedBox(height: 8),
                            Text(l.newPlayer, style: rubik(22, weight: FontWeight.w600)),
                          ]),
                        ),
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
