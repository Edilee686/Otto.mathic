import 'dart:math';

/// "Always 5" mind-reading magic: think of n, double it, add 2k, halve it,
/// take away n. The result is always k. The first show uses k = 5 (the
/// classic); later shows pick a new k so the trick stays surprising.
class MindMagic {
  MindMagic(this.k);

  factory MindMagic.random(Random random, {bool classic = false}) =>
      MindMagic(classic ? 5 : 2 + random.nextInt(8)); // 2..9

  final int k;
  int get add => 2 * k;

  static const minSecret = 1;
  static const maxSecret = 20;

  /// Expected answer after each step, for secret number [n].
  int afterDouble(int n) => 2 * n;
  int afterAdd(int n) => 2 * n + add;
  int afterHalve(int n) => n + k;
  int afterSubtract(int n) => k;

  List<int> expected(int n) => [afterDouble(n), afterAdd(n), afterHalve(n), afterSubtract(n)];
}
