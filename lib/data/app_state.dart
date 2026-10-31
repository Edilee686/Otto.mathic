import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/adaptive.dart';
import '../logic/generators.dart';
import 'models.dart';

const int maxProfiles = 4;
const supportedLanguages = ['en', 'he', 'ru'];

/// Result of saving a finished round, used by the results screen.
class RoundOutcome {
  const RoundOutcome({
    required this.correct,
    required this.total,
    required this.stars,
    required this.coins,
    required this.levelDelta,
    this.trickUnlocked = false,
    this.isTrick = false,
  });
  final int correct, total, stars, coins, levelDelta;
  final bool trickUnlocked, isTrick;
}

/// App-wide state: profiles on the device and who is playing.
/// Stored as JSON in shared preferences (on-device only, no network).
class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _load();
  }

  static const _kProfiles = 'profiles.v1';
  static const _kCurrent = 'currentProfileId';

  final SharedPreferences _prefs;
  final List<Profile> profiles = [];
  Profile? current;

  /// Language picked during onboarding before a profile exists.
  String? pendingLanguage;

  /// True while a new player is being set up although profiles exist.
  bool onboarding = false;

  Locale? get locale {
    final lang = current?.language ?? pendingLanguage;
    return lang == null ? null : Locale(lang);
  }

  bool get canAddProfile => profiles.length < maxProfiles;

  void _load() {
    final raw = _prefs.getString(_kProfiles);
    if (raw != null) {
      for (final p in jsonDecode(raw) as List) {
        profiles.add(Profile.fromJson(Map<String, dynamic>.from(p)));
      }
    }
    final id = _prefs.getString(_kCurrent);
    current = profiles.where((p) => p.id == id).firstOrNull;
  }

  Future<void> _save() async {
    await _prefs.setString(_kProfiles, jsonEncode(profiles.map((p) => p.toJson()).toList()));
    if (current != null) await _prefs.setString(_kCurrent, current!.id);
  }

  void chooseLanguage(String lang) {
    pendingLanguage = lang;
    notifyListeners();
  }

  Future<void> createProfile(String name, int avatarId) async {
    final p = Profile(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      avatarId: avatarId,
      language: pendingLanguage ?? 'en',
      createdAt: DateTime.now(),
    );
    profiles.add(p);
    current = p;
    pendingLanguage = null;
    onboarding = false;
    await _save();
    notifyListeners();
  }

  Future<void> selectProfile(Profile p) async {
    current = p;
    await _save();
    notifyListeners();
  }

  /// Leave the current profile to show the player picker.
  void signOut() {
    current = null;
    pendingLanguage = null;
    onboarding = false;
    _prefs.remove(_kCurrent);
    notifyListeners();
  }

  void startNewPlayer() {
    current = null;
    pendingLanguage = null;
    onboarding = true;
    notifyListeners();
  }

  void cancelNewPlayer() {
    onboarding = false;
    pendingLanguage = null;
    notifyListeners();
  }

  Future<RoundOutcome> finishRound(SkillId skill, List<bool> answers) async {
    final p = current!;
    final correct = answers.where((a) => a).length;
    final stars = starsFor(correct, answers.length);
    final coins = correct;
    p.coins += coins;
    if (skill == SkillId.trickX11) {
      final t = p.trick(skill.name);
      t.practisedCount++;
      final newlyUnlocked = !t.unlocked && correct >= trickUnlockCorrect;
      if (newlyUnlocked) t.unlocked = true;
      final s = p.skill(skill.name);
      if (stars > s.bestStars) s.bestStars = stars;
      await _save();
      notifyListeners();
      return RoundOutcome(
          correct: correct,
          total: answers.length,
          stars: stars,
          coins: coins,
          levelDelta: 0,
          trickUnlocked: newlyUnlocked,
          isTrick: true);
    }
    final s = p.skill(skill.name);
    s.last20 = pushAnswers(s.last20, answers);
    final change = evaluateLevel(s.level, s.last20);
    if (change.delta != 0) {
      s.level = change.newLevel;
      s.last20 = []; // fresh start at the new level
    }
    if (stars > s.bestStars) s.bestStars = stars;
    await _save();
    notifyListeners();
    return RoundOutcome(
        correct: correct,
        total: answers.length,
        stars: stars,
        coins: coins,
        levelDelta: change.delta);
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
