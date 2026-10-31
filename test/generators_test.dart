import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_tricksters/logic/generators.dart';
import 'package:number_tricksters/logic/mind_magic.dart';
import 'package:number_tricksters/logic/problem.dart';

int calc(Problem p) => switch (p.op) {
      Op.add => p.a + p.b,
      Op.sub => p.a - p.b,
      Op.mul => p.a * p.b,
      Op.div => p.a ~/ p.b,
    };

void main() {
  final random = Random(42);

  for (final skill in SkillId.values) {
    for (var level = 1; level <= maxLevel; level++) {
      test('$skill level $level: 1000 problems with correct whole answers', () {
        final gen = SkillGenerator.forSkill(skill, random);
        for (var i = 0; i < 1000; i++) {
          final p = gen.generate(level);
          if (skill == SkillId.makeTen) {
            expect(p.a + p.answer, p.b, reason: 'complement: $p');
          } else {
            expect(p.answer, calc(p), reason: '$p');
          }
          expect(p.answer, greaterThanOrEqualTo(0), reason: '$p');
          expect(p.a, greaterThanOrEqualTo(0), reason: '$p');
          expect(p.b, greaterThanOrEqualTo(0), reason: '$p');
          expect(p.answer, lessThan(10000), reason: 'fits the 4-digit pad: $p');
          expect(p.hintSteps, isNotEmpty, reason: '$p');
          if (p.op == Op.div) {
            expect(p.b, isNot(0));
            expect(p.a % p.b, 0, reason: 'whole-number division: $p');
          }
        }
      });
    }
  }

  test('addition level ranges', () {
    final g = AdditionGenerator(random);
    for (var i = 0; i < 1000; i++) {
      expect(g.generate(1).answer, lessThanOrEqualTo(10));
      expect(g.generate(2).answer, lessThanOrEqualTo(20));
      final noCarry = g.generate(3);
      expect(noCarry.a % 10 + noCarry.b % 10, lessThan(10), reason: '$noCarry');
      expect(noCarry.answer, lessThan(100));
      final carry = g.generate(4);
      expect(carry.a % 10 + carry.b % 10, greaterThanOrEqualTo(10), reason: '$carry');
      expect(carry.answer, lessThan(100), reason: '$carry');
      expect(g.generate(5).answer, lessThanOrEqualTo(999));
    }
  });

  test('subtraction borrow rules', () {
    final g = SubtractionGenerator(random);
    for (var i = 0; i < 1000; i++) {
      final nb = g.generate(3);
      expect(nb.b % 10, lessThanOrEqualTo(nb.a % 10), reason: 'no borrow: $nb');
      final b = g.generate(4);
      expect(b.b % 10, greaterThan(b.a % 10), reason: 'needs borrow: $b');
      expect(b.answer, greaterThan(0));
    }
  });

  test('times tables stay within 10 × 10 below the top level', () {
    final g = MultiplicationGenerator(random);
    for (var level = 1; level < maxLevel; level++) {
      for (var i = 0; i < 500; i++) {
        final p = g.generate(level);
        expect(p.a, lessThanOrEqualTo(10));
        expect(p.b, lessThanOrEqualTo(10));
      }
    }
  });

  test('×11 trick: digits add to 9 or less, answer is first-sum-last', () {
    final g = TimesElevenGenerator(random);
    for (var i = 0; i < 1000; i++) {
      final p = g.generate(1);
      final t = p.a ~/ 10, o = p.a % 10;
      expect(p.a, inInclusiveRange(10, 99));
      expect(t + o, lessThanOrEqualTo(9));
      expect(p.answer, int.parse('$t${t + o}$o'));
    }
  });

  test('×5 trick uses even two-digit numbers', () {
    final g = TimesFiveGenerator(random);
    for (var i = 0; i < 1000; i++) {
      final p = g.generate(1);
      expect(p.a.isEven, isTrue);
      expect(p.a, inInclusiveRange(12, 98));
      expect(p.answer, p.a * 10 ~/ 2);
    }
  });

  test("Juggler's Balls: targets per level and 4 distinct valid choices", () {
    final g = MakeTenGenerator(random);
    for (var level = 1; level <= maxLevel; level++) {
      for (var i = 0; i < 1000; i++) {
        final p = g.generate(level);
        expect(p.b, MakeTenGenerator.targetFor(level));
        expect(p.answer, greaterThan(0));
        final c = g.choices(p);
        expect(c.length, 4);
        expect(c.toSet().length, 4);
        expect(c, contains(p.answer));
        expect(c.every((x) => x > 0 && x < p.b), isTrue, reason: '$p $c');
      }
    }
  });

  test('Always 5: the result is k for every secret number', () {
    for (var k = 2; k <= 9; k++) {
      final m = MindMagic(k);
      for (var n = MindMagic.minSecret; n <= MindMagic.maxSecret; n++) {
        final steps = m.expected(n);
        expect(steps[0], 2 * n);
        expect(steps[1], 2 * n + 2 * k);
        expect(steps[2] * 2, steps[1], reason: 'halving is exact');
        expect(steps[3], k);
      }
    }
  });
}
