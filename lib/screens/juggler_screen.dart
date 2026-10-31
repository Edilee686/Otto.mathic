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
import 'practice_screen.dart' show roundLength;
import 'results_screen.dart';

const _ballColors = [Palette.sky, Palette.pink, Palette.mint, Palette.sun];

/// Juggler's Balls: Otto holds a ball with a number; the child taps the ball
/// that makes 10 (later 20, 50, 100). Tap-to-choose, no typing, no timer.
class JugglerScreen extends StatefulWidget {
  const JugglerScreen({super.key, this.random});
  final Random? random;

  @override
  State<JugglerScreen> createState() => _JugglerScreenState();
}

class _JugglerScreenState extends State<JugglerScreen> {
  late final MakeTenGenerator _gen = MakeTenGenerator(widget.random ?? Random());
  late int _level;
  late Problem _problem;
  late List<int> _choices;
  final Set<int> _wrongPicks = {};
  final List<bool> _answers = [];
  int? _picked;
  int _balls = 0;
  int _wobble = 0;
  bool _busy = false;
  bool _started = false;
  bool _reveal = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _level = AppScope.of(context).current!.skill(SkillId.makeTen.name).level;
      _next();
    }
  }

  void _next() {
    _problem = _gen.generate(_level);
    _choices = _gen.choices(_problem);
    _wrongPicks.clear();
    _picked = null;
    _reveal = false;
    _busy = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _pick(int value) {
    if (_busy || _wrongPicks.contains(value)) return;
    if (value == _problem.answer) {
      setState(() {
        _picked = value;
        _answers.add(_wrongPicks.isEmpty);
        if (_wrongPicks.isEmpty) _balls = min(8, _balls + 1);
        _busy = true;
      });
      _timer = Timer(const Duration(milliseconds: 900), _advance);
    } else {
      setState(() {
        _wrongPicks.add(value);
        _wobble++;
        if (_wrongPicks.length == 1) _balls = max(0, _balls - 1);
        if (_wrongPicks.length >= 2) {
          _answers.add(false);
          _reveal = true;
          _picked = _problem.answer;
          _busy = true;
        }
      });
      if (_reveal) _timer = Timer(const Duration(milliseconds: 1800), _advance);
    }
  }

  Future<void> _advance() async {
    if (!mounted) return;
    if (_answers.length >= roundLength) {
      final nav = Navigator.of(context);
      final outcome = await AppScope.of(context).finishRound(SkillId.makeTen, List.of(_answers));
      nav.pushReplacement(MaterialPageRoute(
          builder: (_) => ResultsScreen(
                outcome: outcome,
                onAgain: () => nav.pushReplacement(
                    MaterialPageRoute(builder: (_) => const JugglerScreen())),
              )));
      return;
    }
    setState(_next);
  }

  Widget _ball(int value, Color color, {double size = 78, bool faded = false, bool ring = false, Key? key}) {
    return AnimatedOpacity(
      key: key,
      duration: const Duration(milliseconds: 250),
      opacity: faded ? 0.25 : 1,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        scale: ring ? 1.12 : 1,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.35, -0.4),
              colors: [Color.lerp(color, Colors.white, 0.45)!, color],
            ),
            border: ring ? Border.all(color: Palette.mint, width: 5) : null,
            boxShadow: softShadow,
          ),
          child: Text('$value',
              textDirection: TextDirection.ltr,
              style: rubik(size * 0.4, weight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppScaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close_rounded, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(child: SoftProgress(_answers.length / roundLength)),
              const SizedBox(width: 12),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text('${min(_answers.length + 1, roundLength)} / $roundLength',
                    style: rubik(16, weight: FontWeight.w600, color: Palette.inkSoft)),
              ),
              const SizedBox(width: 12),
            ]),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Otto(
                      size: 120,
                      balls: _balls,
                      mood: _picked != null && !_reveal
                          ? OttoMood.cheering
                          : (_wrongPicks.isEmpty ? OttoMood.happy : OttoMood.thinking),
                    ),
                    const SizedBox(height: 4),
                    Text(l.jugglerAsk(_problem.b),
                        textAlign: TextAlign.center, style: rubik(22, weight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    Wobble(
                      trigger: _wobble,
                      child: SoftCard(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              _ball(_problem.a, Palette.violet, size: 76),
                              Text('  +  ', style: rubik(36, weight: FontWeight.w800)),
                              _picked == null
                                  ? Container(
                                      width: 76,
                                      height: 76,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Palette.lilac,
                                        border: Border.all(color: Palette.violet.withValues(alpha: 0.3), width: 3),
                                      ),
                                      child: Text('?', style: rubik(34, weight: FontWeight.w800, color: Palette.violet)),
                                    )
                                  : _ball(_picked!, _reveal ? Palette.coral : Palette.mint, size: 76),
                              Text('  =  ${_problem.b}',
                                  key: const ValueKey('juggler-question'),
                                  style: rubik(36, weight: FontWeight.w800)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: Center(
                        child: _wrongPicks.isNotEmpty
                            ? Directionality(
                                textDirection: TextDirection.ltr,
                                child: FittedBox(
                                  child: Text(_problem.hintSteps.first,
                                      style: rubik(20, weight: FontWeight.w600, color: const Color(0xFF9A6200))),
                                ),
                              )
                            : null,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: [
                          for (var i = 0; i < _choices.length; i++)
                            Semantics(
                              button: true,
                              label: '${_choices[i]}',
                              excludeSemantics: true,
                              child: GestureDetector(
                                onTap: () => _pick(_choices[i]),
                                child: _ball(
                                  _choices[i],
                                  _ballColors[i % _ballColors.length],
                                  key: ValueKey('choice-${_choices[i]}'),
                                  faded: _wrongPicks.contains(_choices[i]) ||
                                      (_picked != null && _choices[i] != _picked),
                                  ring: _picked == _choices[i],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
