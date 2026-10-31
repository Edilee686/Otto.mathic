/// A single arithmetic question. Hints are written in pure math notation
/// (numbers and symbols only) so they read the same in every language.
class Problem {
  const Problem({
    required this.a,
    required this.b,
    required this.op,
    required this.answer,
    this.hintSteps = const [],
  });

  final int a;
  final int b;
  final Op op;
  final int answer;
  final List<String> hintSteps;

  String get question => '$a ${op.symbol} $b';

  @override
  String toString() => '$question = $answer';
}

enum Op {
  add('+'),
  sub('−'),
  mul('×'),
  div('÷');

  const Op(this.symbol);
  final String symbol;
}
