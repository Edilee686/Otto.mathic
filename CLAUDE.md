# Number Tricksters

Kids math app (ages 5-12, MVP targets 7-10). Mascot: Otto, a purple octopus magician. Magic-circus theme.
Spec: https://claude.ai/artifact/Hs6FwEAUFdjTaLtCaqaFQf (8-step build plan, data model, screens).

## Rules
- Flutter (Dart), Android first. Offline only: no network, no analytics, no ads, no purchases.
- Every visible string lives in `lib/l10n/app_{en,he,ru}.arb`. Never hard-code UI text in widgets.
- Hebrew is right-to-left, but equations, number pads and hints stay left-to-right (`Directionality(ltr)`).
- Mistakes get a gentle wobble and a hint. Never red, never a buzzer. Coral (#F28A6B) is "try again".
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

## MVP status (31 Oct 2026)
Done: build-plan steps 1-4 plus one trick from step 6 (×11).
Next: column board (step 5), the other 5 tricks (step 6), tour map with 3 towns (step 7),
parent gate + daily limit (step 8), Drift instead of shared_preferences if queries get complex.
