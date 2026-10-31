import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/app_state.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screens.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(NumberTrickstersApp(state: AppState(prefs)));
}

class NumberTrickstersApp extends StatelessWidget {
  const NumberTrickstersApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          locale: state.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const RootGate(),
        ),
      ),
    );
  }
}

/// Picks the first screen: home for the current player, the player picker,
/// or the first-launch flow (language, then name).
class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (state.current != null) return HomeScreen(key: ValueKey(state.current!.id));
    if (state.profiles.isNotEmpty && !state.onboarding) return const ProfilePickerScreen();
    return const LanguageScreen();
  }
}
