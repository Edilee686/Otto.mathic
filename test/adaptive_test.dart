import 'package:flutter_test/flutter_test.dart';
import 'package:number_tricksters/logic/adaptive.dart';
import 'package:number_tricksters/logic/generators.dart';

void main() {
  test('history keeps only the last 20 answers', () {
    final h = pushAnswers(List.filled(15, true), List.filled(10, false));
    expect(h.length, 20);
    expect(h.where((a) => !a).length, 10);
  });

  test('no change with fewer than 10 answers', () {
    expect(evaluateLevel(2, List.filled(9, true)).delta, 0);
  });

  test('above 85% steps up, below 60% steps down, otherwise stays', () {
    expect(evaluateLevel(2, [...List.filled(9, true), false]).delta, 1); // 90%
    expect(evaluateLevel(2, [...List.filled(5, true), ...List.filled(5, false)]).delta, -1); // 50%
    expect(evaluateLevel(2, [...List.filled(7, true), ...List.filled(3, false)]).delta, 0); // 70%
  });

  test('level stays within 1..maxLevel', () {
    expect(evaluateLevel(maxLevel, List.filled(20, true)).newLevel, maxLevel);
    expect(evaluateLevel(1, List.filled(20, false)).newLevel, 1);
  });

  test('stars', () {
    expect(starsFor(10, 10), 3);
    expect(starsFor(9, 10), 3);
    expect(starsFor(7, 10), 2);
    expect(starsFor(3, 10), 1);
  });
}
