import 'dart:math';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../l10n/app_localizations.dart';
import '../logic/mind_magic.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/otto.dart';

enum _Stage { intro, think, double, add, halve, subtract, reveal }

/// "Otto reads minds" (Always 5): the child thinks of a number and works out
/// each step in their head; Otto's prediction under the hat always matches.
class MindMagicScreen extends StatefulWidget {
  const MindMagicScreen({super.key, this.magic});
  final MindMagic? magic;

  @override
  State<MindMagicScreen> createState() => _MindMagicScreenState();
}

class _MindMagicScreenState extends State<MindMagicScreen> {
  late MindMagic _magic;
  bool _initialised = false;
  _Stage _stage = _Stage.intro;
  int _secret = 0;
  int _current = 0; // value after the last finished step
  String _input = '';
  int _wrong = 0;
  int _wobble = 0;
  String? _note; // hint or range message
  bool _newCard = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;
    final played = AppScope.of(context).current!.trick(mindAlways5Card).practisedCount;
    // The first show is the classic "always 5"; later shows change the number.
    _magic = widget.magic ?? MindMagic.random(Random(), classic: played == 0);
  }

  int get _expected => switch (_stage) {
        _Stage.double => _magic.afterDouble(_secret),
        _Stage.add => _magic.afterAdd(_secret),
        _Stage.halve => _magic.afterHalve(_secret),
        _Stage.subtract => _magic.afterSubtract(_secret),
        _ => 0,
      };

  String get _hint => switch (_stage) {
        _Stage.double => '$_current + $_current',
        _Stage.add => '$_current + ${_magic.add}',
        _Stage.halve => '$_current ÷ 2',
        _Stage.subtract => '$_current − $_secret',
        _ => '',
      };

  String get _equation => switch (_stage) {
        _Stage.think => '',
        _Stage.double => '$_current × 2 =',
        _Stage.add => '$_current + ${_magic.add} =',
        _Stage.halve => '$_current ÷ 2 =',
        _Stage.subtract => '$_current − $_secret =',
        _ => '',
      };

  void _digit(int d) {
    if (_input.length >= 3) return;
    setState(() => _input = _input == '0' ? '$d' : '$_input$d');
  }

  void _backspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  Future<void> _submit() async {
    if (_input.isEmpty) return;
    final value = int.parse(_input);
    final l = AppLocalizations.of(context);
    if (_stage == _Stage.think) {
      if (value < MindMagic.minSecret || value > MindMagic.maxSecret) {
        setState(() {
          _wobble++;
          _note = l.mindRange;
          _input = '';
        });
        return;
      }
      setState(() {
        _secret = value;
        _current = value;
        _advanceStage();
      });
      return;
    }
    if (value == _expected || _wrong >= 1) {
      // Right, or second miss: show the right value and keep the magic going.
      setState(() {
        _current = _expected;
        _advanceStage();
      });
      if (_stage == _Stage.reveal) {
        final isNew = await AppScope.of(context).unlockCard(mindAlways5Card);
        if (mounted) setState(() => _newCard = isNew);
      }
    } else {
      setState(() {
        _wrong++;
        _wobble++;
        _note = _hint;
        _input = '';
      });
    }
  }

  void _advanceStage() {
    _stage = _Stage.values[_stage.index + 1];
    _input = '';
    _wrong = 0;
    _note = null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final speech = switch (_stage) {
      _Stage.intro => l.mindPrediction,
      _Stage.think => l.mindThink,
      _Stage.double => l.mindDouble,
      _Stage.add => l.mindAdd(_magic.add),
      _Stage.halve => l.mindHalve,
      _Stage.subtract => l.mindSubtract,
      _Stage.reveal => l.mindReveal(_magic.k),
    };
    final askingNumber = _stage != _Stage.intro && _stage != _Stage.reveal;

    return AppScaffold(
      appBar: AppBar(title: Text(l.mindTitle, style: rubik(20, weight: FontWeight.w700))),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Otto(
                        size: askingNumber ? 100 : 130,
                        mood: switch (_stage) {
                          _Stage.think => OttoMood.eyesClosed,
                          _Stage.reveal => OttoMood.cheering,
                          _ => OttoMood.happy,
                        },
                      ),
                      const SizedBox(width: 12),
                      _PredictionCard(value: _magic.k, open: _stage == _Stage.reveal),
                    ]),
                    const SizedBox(height: 10),
                    SpeechBubble(speech, size: 19),
                    if (askingNumber) ...[
                      const SizedBox(height: 14),
                      Wobble(
                        trigger: _wobble,
                        child: SoftCard(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text('$_equation ',
                                    key: const ValueKey('mind-equation'),
                                    style: rubik(40, weight: FontWeight.w800)),
                                Container(
                                  constraints: const BoxConstraints(minWidth: 84),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: Palette.lilac, borderRadius: BorderRadius.circular(16)),
                                  child: Text(_input.isEmpty ? ' ' : _input,
                                      textAlign: TextAlign.center,
                                      style: rubik(40, weight: FontWeight.w800)),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 40),
                        child: Center(
                          child: _note == null
                              ? null
                              : Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.lightbulb_rounded, color: Palette.coral),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(_note!,
                                        textDirection: _note == l.mindRange
                                            ? Directionality.of(context)
                                            : TextDirection.ltr,
                                        style: rubik(18, weight: FontWeight.w700, color: Palette.coral)),
                                  ),
                                ]),
                        ),
                      ),
                    ],
                    if (_stage == _Stage.intro) ...[
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const ValueKey('mind-start'),
                        onPressed: () => setState(_advanceStage),
                        child: Text(l.next),
                      ),
                    ],
                    if (_stage == _Stage.reveal) ...[
                      if (_newCard) ...[
                        const SizedBox(height: 12),
                        Text(l.trickUnlocked,
                            textAlign: TextAlign.center,
                            style: rubik(17, weight: FontWeight.w600, color: Palette.violetDeep)),
                      ],
                      const SizedBox(height: 22),
                      Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: [
                        OutlinedButton.icon(
                          key: const ValueKey('mind-how'),
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MindHowScreen(magic: _magic))),
                          icon: const Icon(Icons.help_outline_rounded),
                          label: Text(l.howItWorks),
                        ),
                        FilledButton.icon(
                          key: const ValueKey('mind-perform'),
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ShowTimeScreen(magic: _magic))),
                          icon: const Icon(Icons.theater_comedy_rounded),
                          label: Text(l.performIt),
                        ),
                      ]),
                    ],
                    const SizedBox(height: 12),
                  ]),
                ),
              ),
            ),
          ),
          if (askingNumber)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: NumberPad(
                  onDigit: _digit,
                  onBackspace: _backspace,
                  onSubmit: _submit,
                  submitLabel: l.check,
                  canSubmit: _input.isNotEmpty,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

/// Otto's sealed prediction: a card that flips open at the reveal.
class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.value, required this.open});
  final int value;
  final bool open;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: child,
      ),
      child: Container(
        key: ValueKey(open),
        width: 84,
        height: 112,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: open
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF9B82FF), Palette.violet]),
          color: open ? Colors.white : null,
          borderRadius: BorderRadius.circular(18),
          border: open ? Border.all(color: Palette.sun, width: 4) : null,
          boxShadow: softShadow,
        ),
        child: open
            ? Text('$value',
                key: const ValueKey('prediction'),
                style: rubik(52, weight: FontWeight.w800, color: Palette.violet))
            : const Icon(Icons.auto_awesome_rounded, color: Palette.sun, size: 36),
      ),
    );
  }
}

/// "How does it work?": the secret number is a bag of balls.
class MindHowScreen extends StatelessWidget {
  const MindHowScreen({super.key, required this.magic});
  final MindMagic magic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget bag() => const Padding(
          padding: EdgeInsets.all(2),
          child: Icon(Icons.shopping_bag_rounded, color: Palette.violet, size: 40),
        );
    Widget balls(int n) => Wrap(spacing: 4, runSpacing: 4, children: [
          for (var i = 0; i < n; i++)
            Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: Palette.sun, shape: BoxShape.circle)),
        ]);
    final rows = [
      (l.mindHow1, [bag(), bag()], 0),
      (l.mindHow2(magic.add), [bag(), bag()], magic.add),
      (l.mindHow3(magic.k), [bag()], magic.k),
      (l.mindHow4(magic.k), <Widget>[], magic.k),
    ];
    return AppScaffold(
      appBar: AppBar(title: Text(l.howItWorks, style: rubik(20, weight: FontWeight.w700))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final (i, (text, bags, n)) in rows.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SoftCard(
                  child: Row(children: [
                    SymbolTile('${i + 1}', color: Palette.violet, size: 40),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(text, style: rubik(17, weight: FontWeight.w600, height: 1.35)),
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(children: [
                            ...bags,
                            if (bags.isNotEmpty && n > 0) const SizedBox(width: 10),
                            if (n > 0) Flexible(child: balls(n)),
                          ]),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            const SizedBox(height: 8),
            Center(
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => ShowTimeScreen(magic: magic))),
                icon: const Icon(Icons.theater_comedy_rounded),
                label: Text(l.performIt),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show Time: the script the child reads to a parent or friend.
class ShowTimeScreen extends StatelessWidget {
  const ShowTimeScreen({super.key, required this.magic});
  final MindMagic magic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lines = [
      l.scriptThink,
      l.scriptDouble,
      l.scriptAdd(magic.add),
      l.scriptHalve,
      l.scriptSubtract,
      l.scriptReveal(magic.k),
    ];
    return AppScaffold(
      appBar: AppBar(title: Text(l.showTime, style: rubik(20, weight: FontWeight.w700))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(child: Otto(size: 110, mood: OttoMood.cheering)),
            const SizedBox(height: 8),
            SpeechBubble(l.showTimeIntro, size: 18),
            const SizedBox(height: 16),
            for (final (i, line) in lines.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SoftCard(
                  color: i == lines.length - 1 ? const Color(0xFFFFF3D6) : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    SymbolTile('${i + 1}', color: i == lines.length - 1 ? Palette.sun : Palette.violet, size: 40),
                    const SizedBox(width: 14),
                    Expanded(child: Text(line, style: rubik(21, weight: FontWeight.w700))),
                  ]),
                ),
              ),
            const SizedBox(height: 12),
            Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: Text(l.done),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
