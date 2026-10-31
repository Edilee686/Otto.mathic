import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../logic/generators.dart';
import '../logic/problem.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';
import 'results_screen.dart';

const int roundLength = 10;

/// Juggling Practice (and trick practice): 10 problems while Otto juggles.
/// Each first-try correct answer adds a ball, a mistake drops one.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, required this.skill, this.random});
  final SkillId skill;
  final Random? random;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

enum _Feedback { none, correct, almost, reveal }

class _PracticeScreenState extends State<PracticeScreen> {
  late final SkillGenerator _gen = SkillGenerator.forSkill(widget.skill, widget.random);
  late Problem _problem;
  late int _level;
  final List<bool> _answers = [];
  String _input = '';
  int _wrongTries = 0;
  int _balls = 0;
  int _wobble = 0;
  bool _showHint = false;
  bool _busy = false;
  _Feedback _feedback = _Feedback.none;
  int _cheer = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_answers.isEmpty && _input.isEmpty && _feedback == _Feedback.none && !_started) {
      _started = true;
      _level = AppScope.of(context).current!.skill(widget.skill.name).level;
      _problem = _nextProblem();
    }
  }

  bool _started = false;
  final Set<String> _seen = {};

  Problem _nextProblem() {
    // Avoid repeating a question inside one round when possible.
    for (var i = 0; i < 20; i++) {
      final p = _gen.generate(_level);
      if (_seen.add(p.question)) return p;
    }
    return _gen.generate(_level);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _digit(int d) {
    if (_busy || _input.length >= 4) return;
    setState(() {
      _input = (_input == '0') ? '$d' : '$_input$d';
      if (_feedback == _Feedback.almost) _feedback = _Feedback.none;
    });
  }

  void _backspace() {
    if (_busy || _input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _submit() {
    if (_busy || _input.isEmpty) return;
    final value = int.parse(_input);
    if (value == _problem.answer) {
      setState(() {
        _answers.add(_wrongTries == 0);
        if (_wrongTries == 0) _balls = min(8, _balls + 1);
        _feedback = _Feedback.correct;
        _cheer = Random().nextInt(3);
        _busy = true;
      });
      _timer = Timer(const Duration(milliseconds: 900), _advance);
    } else {
      setState(() {
        _wrongTries++;
        _wobble++;
        if (_wrongTries == 1) _balls = max(0, _balls - 1);
        _showHint = true;
        if (_wrongTries >= 2) {
          _answers.add(false);
          _feedback = _Feedback.reveal;
          _busy = true;
        } else {
          _feedback = _Feedback.almost;
          _input = '';
        }
      });
      if (_wrongTries >= 2) _timer = Timer(const Duration(milliseconds: 2200), _advance);
    }
  }

  Future<void> _advance() async {
    if (!mounted) return;
    if (_answers.length >= roundLength) {
      final state = AppScope.of(context);
      final nav = Navigator.of(context);
      final outcome = await state.finishRound(widget.skill, List.of(_answers));
      nav.pushReplacement(MaterialPageRoute(
          builder: (_) => ResultsScreen(skill: widget.skill, outcome: outcome)));
      return;
    }
    setState(() {
      _problem = _nextProblem();
      _input = '';
      _wrongTries = 0;
      _showHint = false;
      _feedback = _Feedback.none;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cheers = [l.cheer1, l.cheer2, l.cheer3];
    final feedbackText = switch (_feedback) {
      _Feedback.correct => cheers[_cheer],
      _Feedback.almost => l.almost,
      _Feedback.reveal => l.answerIs(_problem.answer),
      _Feedback.none => '',
    };
    final feedbackColor = _feedback == _Feedback.correct ? Palette.mint : Palette.coral;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final compact = box.maxHeight < 700;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(children: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close_rounded, size: 32),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _answers.length / roundLength,
                      minHeight: 12,
                      color: Palette.marigold,
                      backgroundColor: Palette.nightDeep,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text('${min(_answers.length + 1, roundLength)} / $roundLength',
                      style: rubik(18, weight: FontWeight.w600)),
                ),
                const SizedBox(width: 12),
              ]),
            ),
            Otto(
              size: compact ? 100 : 130,
              balls: _balls,
              mood: _feedback == _Feedback.correct
                  ? OttoMood.cheering
                  : (_feedback == _Feedback.none ? OttoMood.happy : OttoMood.thinking),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wobble(
                trigger: _wobble,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Palette.cream,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: _feedback == _Feedback.correct ? Palette.mint : Colors.transparent,
                      width: 4,
                    ),
                  ),
                  // Equations always read left-to-right, also in Hebrew.
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('${_problem.question} = ',
                            key: const ValueKey('question'),
                            style: rubik(48, weight: FontWeight.w700, color: Palette.ink)),
                        Container(
                          constraints: const BoxConstraints(minWidth: 90),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Palette.violet, width: 4)),
                          ),
                          child: Text(
                            _feedback == _Feedback.reveal ? '${_problem.answer}' : (_input.isEmpty ? ' ' : _input),
                            key: const ValueKey('answer'),
                            textAlign: TextAlign.center,
                            style: rubik(48,
                                weight: FontWeight.w700,
                                color: _feedback == _Feedback.reveal ? Palette.violet : Palette.ink),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 36,
              child: Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_feedback == _Feedback.correct)
                    const Icon(Icons.check_circle_rounded, color: Palette.mint),
                  if (_feedback == _Feedback.almost || _feedback == _Feedback.reveal)
                    const Icon(Icons.lightbulb_rounded, color: Palette.coral),
                  const SizedBox(width: 6),
                  Text(feedbackText, style: rubik(22, weight: FontWeight.w700, color: feedbackColor)),
                ]),
              ),
            ),
            if (_showHint)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(children: [
                    for (final step in _problem.hintSteps)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(step,
                            style: rubik(20, weight: FontWeight.w600, color: Palette.marigold)),
                      ),
                  ]),
                ),
              )
            else
              TextButton.icon(
                onPressed: _busy ? null : () => setState(() => _showHint = true),
                icon: const Icon(Icons.lightbulb_outline_rounded, color: Palette.marigold),
                label: Text(l.hint, style: rubik(20, weight: FontWeight.w600, color: Palette.marigold)),
              ),
            const Spacer(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: NumberPad(
                  onDigit: _digit,
                  onBackspace: _backspace,
                  onSubmit: _submit,
                  submitLabel: l.check,
                  canSubmit: _input.isNotEmpty && !_busy,
                ),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
