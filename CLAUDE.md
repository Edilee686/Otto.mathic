# Number Tricksters

Kids math app (ages 5-12, MVP targets 7-10). Mascot: Otto, a purple octopus magician. Magic-circus theme.
Spec: https://claude.ai/artifact/Hs6FwEAUFdjTaLtCaqaFQf (8-step build plan, data model, screens).

## Rules
- Flutter (Dart), Android first. Offline only: no network, no analytics, no ads, no purchases.
- Every visible string lives in `lib/l10n/app_{en,he,ru}.arb`. Never hard-code UI text in widgets.
- Hebrew is right-to-left, but equations, number pads and hints stay left-to-right (`Directionality(ltr)`).
- Mistakes get a gentle wobble and a hint. Never red, never a buzzer. Coral (#FF8A6B) is "try again".
- Look (refreshed 31 Oct 2026 at Edi's request, "more contemporary and easier on the eye"): light lavender-to-peach
  background (`AppScaffold`), white `SoftCard`s with soft shadows, violet #7B5CF0 primary, sun #FFB938 for stars.
  Use `Palette`, `rubik()`, `SoftCard`, `SymbolTile` from `lib/theme.dart` and `lib/widgets/common.dart`.
- Problems are generated randomly per level in `lib/logic/generators.dart`, never hard-coded, whole-number answers.
- Adaptive rule: last 20 answers per skill; >85% steps up, <60% steps down (needs 10+ answers).
- Only the child's first name/nickname is stored, on the device.
- Numbers on problem screens are at least 32pt; tap targets at least 48dp.

## Layout
- `lib/main.dart` app + RootGate (onboarding / player picker / home)
- `lib/data/` profiles and progress (`AppState`, saved as JSON in shared_preferences)
- `lib/logic/` generators, adaptive level, stars
- `lib/screens/` onboarding, home, practice (Juggling Practice), trick demo, results
- `lib/widgets/otto.dart` placeholder Otto drawn in code (swap for Rive/art later)

## Commands
- `flutter test` (generators run 1,000 problems per level per skill)
- `flutter analyze`
- `flutter run` (Android device/emulator) or `flutter run -d chrome`
- `flutter build apk --release`

## Repo and brand
Code lives in GitHub `Edilee686/Otto.mathic` (moved from Otto.English on 31 Oct 2026). The app icon and logo are drawn
from Otto's painter: `flutter test tool/render_icon_test.dart` writes build/icon/otto.png; logo files are in assets/brand/.
GitHub Actions (`.github/workflows/android-apk.yml`) builds a test APK artifact on every push to main.

## MVP status (31 Oct 2026)
Done: build-plan steps 1-4; Trick School with ×11 and ×5 (`TrickDef` list in `screens/trick_screens.dart`);
"Otto Reads Minds" (Always 5, with How-it-works and Show Time script); Juggler's Balls (make 10/20/50/100).
Ideas backlog (Hebrew doc): https://claude.ai/artifact/FF2VeKcYF6MgNv4L7UsquP
Next: column board (step 5), the other 5 tricks (step 6), tour map with 3 towns (step 7),
parent gate + daily limit (step 8), Drift instead of shared_preferences if queries get complex.
