# Number Tricksters (MVP)

A free, offline math game for kids with Otto the octopus magician. English, Hebrew (right-to-left) and Russian.

## What is in this MVP
- First launch: choose language (English / עברית / Русский), then the child's name and a buddy avatar. Up to 4 players.
- Juggling Practice for + − × ÷: rounds of 10 problems, 5 levels each, Otto juggles a ball per correct answer.
  Wrong answers wobble and show a hint; after two tries the answer is shown. Level adapts automatically.
- Trick School: the ×11 trick. Otto demonstrates it in 3 steps, then the child practises. 8 of 10 correct wins the trick card.
- Results with 1-3 stars and coins; progress is saved on the device.

## Run it on your Android phone or emulator
1. Install Flutter (https://docs.flutter.dev/get-started/install) and Android Studio.
2. In this folder: `flutter pub get`, then `flutter run` with a phone connected (USB debugging on) or an emulator open.
3. To make an installable file: `flutter build apk --release`. The APK is in `build/app/outputs/flutter-apk/app-release.apk`.

Quick look in a browser instead: `flutter run -d chrome`.

## Tests
`flutter test`

Font: Rubik (SIL Open Font License, see `assets/fonts/OFL.txt`).
