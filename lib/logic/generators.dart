import 'dart:math';

import 'problem.dart';

/// Skill ids double as keys in saved progress.
enum SkillId { add, sub, mul, div, trickX11 }

const int maxLevel = 5;

/// One generator per skill. `generate(level)` returns a random problem inside
/// that level's number range, always with a whole-number answer.
abstract class SkillGenerator {
  SkillGenerator(this.random);
  final Random random;

  Problem generate(int level);

  int _range(int min, int max) => min + random.nextInt(max - min + 1);

  static SkillGenerator forSkill(SkillId id, [Random? random]) {
    final r = random ?? Random();
    return switch (id) {
      SkillId.add => AdditionGenerator(r),
      SkillId.sub => SubtractionGenerator(r),
      SkillId.mul => MultiplicationGenerator(r),
      SkillId.div => DivisionGenerator(r),
      SkillId.trickX11 => TimesElevenGenerator(r),
    };
  }
}

String _dots(int n) => n == 0 ? '0' : '●' * n;

String _splitHintAdd(int a, int b) {
  final tens = (a ~/ 10) * 10 + (b ~/ 10) * 10;
  final ones = a % 10 + b % 10;
  return '${(a ~/ 10) * 10} + ${(b ~/ 10) * 10} = $tens,  '
      '${a % 10} + ${b % 10} = $ones,  $tens + $ones = ${tens + ones}';
}

class AdditionGenerator extends SkillGenerator {
  AdditionGenerator(super.random);

  @override
  Problem generate(int level) {
    late int a, b;
    switch (level.clamp(1, maxLevel)) {
      case 1: // sums within 10
        a = _range(0, 9);
        b = _range(0, 10 - a);
      case 2: // sums within 20
        a = _range(2, 18);
        b = _range(1, 20 - a);
      case 3: // two-digit, no carrying
        final ta = _range(1, 8), oa = _range(0, 9);
        a = ta * 10 + oa;
        b = _range(1, 9 - ta) * 10 + _range(0, 9 - oa);
      case 4: // two-digit with carrying
        final ta = _range(1, 7), oa = _range(1, 9);
        a = ta * 10 + oa;
        b = _range(1, 8 - ta) * 10 + _range(10 - oa, 9);
      default: // three-digit
        a = _range(100, 899);
        b = _range(10, 999 - a);
    }
    final String hint;
    if (a >= 10 || b >= 10) {
      hint = _splitHintAdd(a, b);
    } else if (a + b > 10) {
      // Make 10: 8 + 5 = 8 + 2 + 3
      final big = max(a, b), small = min(a, b), toTen = 10 - big;
      hint = '$big + $toTen + ${small - toTen} = 10 + ${small - toTen}';
    } else {
      hint = '${_dots(a)} + ${_dots(b)}';
    }
    return Problem(a: a, b: b, op: Op.add, answer: a + b, hintSteps: [hint]);
  }
}

class SubtractionGenerator extends SkillGenerator {
  SubtractionGenerator(super.random);

  @override
  Problem generate(int level) {
    late int a, b;
    switch (level.clamp(1, maxLevel)) {
      case 1:
        a = _range(1, 10);
        b = _range(0, a);
      case 2:
        a = _range(11, 20);
        b = _range(1, a);
      case 3: // two-digit, no borrowing
        a = _range(20, 99);
        b = 10 * _range(0, a ~/ 10 - 1) + _range(0, a % 10);
        if (b == 0) b = a % 10 == 0 ? 10 : 1;
      case 4: // two-digit with borrowing
        a = 10 * _range(2, 9) + _range(0, 8);
        b = 10 * _range(0, a ~/ 10 - 2) + _range(a % 10 + 1, 9);
      default: // three-digit
        a = _range(200, 999);
        b = _range(10, a);
    }
    final hints = <String>[];
    if (b >= 10) {
      final tens = (b ~/ 10) * 10;
      hints.add('$a − $tens = ${a - tens},  ${a - tens} − ${b - tens} = ${a - b}');
    } else {
      hints.add('$b + ? = $a');
    }
    return Problem(a: a, b: b, op: Op.sub, answer: a - b, hintSteps: hints);
  }
}

/// Times-table factors unlocked at each level.
const _tableFactors = <int, List<int>>{
  1: [1, 2, 10],
  2: [1, 2, 3, 5, 10],
  3: [2, 3, 4, 5, 6, 10],
  4: [2, 3, 4, 5, 6, 7, 8, 9, 10],
};

class MultiplicationGenerator extends SkillGenerator {
  MultiplicationGenerator(super.random);

  @override
  Problem generate(int level) {
    final lv = level.clamp(1, maxLevel);
    late int a, b;
    if (lv < maxLevel) {
      final factors = _tableFactors[lv]!;
      a = factors[random.nextInt(factors.length)];
      b = _range(1, 10);
      if (random.nextBool()) (a, b) = (b, a);
    } else {
      a = _range(11, 49); // two-digit × one-digit
      b = _range(2, 9);
    }
    final hints = <String>[];
    if (a >= 10 && lv == maxLevel) {
      final tens = (a ~/ 10) * 10;
      hints.add('$tens × $b + ${a % 10} × $b = ${tens * b} + ${(a % 10) * b}');
    } else if (min(a, b) <= 5) {
      final small = min(a, b), big = max(a, b);
      hints.add(small == 0 ? '0' : List.filled(small, '$big').join(' + '));
    } else {
      hints.add('$a × ${b - 1} + $a = ${a * (b - 1)} + $a');
    }
    return Problem(a: a, b: b, op: Op.mul, answer: a * b, hintSteps: hints);
  }
}

class DivisionGenerator extends SkillGenerator {
  DivisionGenerator(super.random);

  @override
  Problem generate(int level) {
    final lv = level.clamp(1, maxLevel);
    late int divisor, quotient;
    if (lv < maxLevel) {
      final factors = _tableFactors[lv]!;
      divisor = factors[random.nextInt(factors.length)];
      quotient = _range(1, 10);
    } else {
      divisor = _range(2, 9);
      quotient = _range(11, 30);
    }
    final dividend = divisor * quotient;
    return Problem(
      a: dividend,
      b: divisor,
      op: Op.div,
      answer: quotient,
      hintSteps: ['$divisor × ? = $dividend'],
    );
  }
}

/// The ×11 trick: two-digit numbers whose digits add to 9 or less,
/// so the answer is "first digit, digit sum, last digit".
class TimesElevenGenerator extends SkillGenerator {
  TimesElevenGenerator(super.random);

  @override
  Problem generate(int level) {
    final tens = _range(1, 8);
    final ones = _range(0, 9 - tens);
    final a = tens * 10 + ones;
    return Problem(
      a: a,
      b: 11,
      op: Op.mul,
      answer: a * 11,
      hintSteps: ['$tens _ $ones', '$tens + $ones = ?'],
    );
  }
}
