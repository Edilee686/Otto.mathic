import 'generators.dart';

/// Rule from the spec: track the last 20 answers per skill. Above 85% correct
/// the level steps up, below 60% it steps down. Decisions need 10+ answers.
class LevelChange {
  const LevelChange(this.newLevel, this.delta);
  final int newLevel;
  final int delta; // -1, 0 or +1
}

const int historySize = 20;
const int minAnswersForChange = 10;

List<bool> pushAnswers(List<bool> history, List<bool> answers) {
  final all = [...history, ...answers];
  return all.length <= historySize ? all : all.sublist(all.length - historySize);
}

LevelChange evaluateLevel(int level, List<bool> history) {
  if (history.length < minAnswersForChange) return LevelChange(level, 0);
  final accuracy = history.where((c) => c).length / history.length;
  if (accuracy > 0.85 && level < maxLevel) return LevelChange(level + 1, 1);
  if (accuracy < 0.60 && level > 1) return LevelChange(level - 1, -1);
  return LevelChange(level, 0);
}

/// 1-3 stars for a round, by first-try accuracy.
int starsFor(int correct, int total) {
  if (total == 0) return 0;
  final r = correct / total;
  if (r >= 0.9) return 3;
  if (r >= 0.7) return 2;
  return 1;
}

const int trickUnlockCorrect = 8;
