import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Buddy avatars a child can pick. Emoji for now; swap for drawn art later.
const buddies = ['🦁', '🐧', '🐻', '🦜', '🐰', '🦊'];

class BuddyAvatar extends StatelessWidget {
  const BuddyAvatar(this.id, {super.key, this.size = 64, this.selected = false});
  final int id;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Palette.cream,
        shape: BoxShape.circle,
        border: Border.all(
            color: selected ? Palette.marigold : Colors.transparent, width: size * 0.07),
      ),
      child: Text(buddies[id % buddies.length], style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

/// Cream "paper" speech bubble for Otto's lines.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.text, {super.key, this.size = 22});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Palette.cream,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: rubik(size, weight: FontWeight.w600, color: Palette.ink)),
    );
  }
}

class StarRow extends StatelessWidget {
  const StarRow(this.stars, {super.key, this.size = 22, this.max = 3});
  final int stars;
  final int max;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$stars / $max ★',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < max; i++)
            Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                size: size, color: Palette.marigold),
        ],
      ),
    );
  }
}

class CoinBadge extends StatelessWidget {
  const CoinBadge(this.coins, {super.key});
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
          color: Palette.nightDeep, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.toll_rounded, color: Palette.marigold, size: 24),
        const SizedBox(width: 6),
        Text('$coins', style: rubik(20, weight: FontWeight.w700)),
      ]),
    );
  }
}

/// Gentle side-to-side wobble for a wrong answer (no buzzer, no red X).
class Wobble extends StatefulWidget {
  const Wobble({super.key, required this.trigger, required this.child});
  final int trigger; // change this value to wobble once
  final Widget child;

  @override
  State<Wobble> createState() => _WobbleState();
}

class _WobbleState extends State<Wobble> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void didUpdateWidget(Wobble old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger && !MediaQuery.of(context).disableAnimations) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => Transform.translate(
        offset: Offset(sin(_c.value * pi * 5) * 12 * (1 - _c.value), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Number pad. Always laid out left-to-right, even in Hebrew.
class NumberPad extends StatelessWidget {
  const NumberPad({super.key, required this.onDigit, required this.onBackspace, required this.onSubmit, required this.submitLabel, this.canSubmit = true});
  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;
  final String submitLabel;
  final bool canSubmit;

  @override
  Widget build(BuildContext context) {
    Widget key(Widget child, VoidCallback? onTap, {String? label, Color? color}) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Semantics(
              button: true,
              label: label,
              excludeSemantics: label != null,
              child: Material(
                color: color ?? Palette.cream,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTap,
                  child: SizedBox(height: 60, child: Center(child: child)),
                ),
              ),
            ),
          ),
        );
    Widget digit(int d) =>
        key(Text('$d', style: rubik(30, weight: FontWeight.w700, color: Palette.ink)), () => onDigit(d), label: '$d');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (final row in const [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          Row(children: [for (final d in row) digit(d)]),
        Row(children: [
          key(const Icon(Icons.backspace_rounded, color: Palette.ink, size: 28), onBackspace,
              label: '⌫'),
          digit(0),
          key(Text(submitLabel, style: rubik(22, weight: FontWeight.w700, color: Palette.ink)),
              canSubmit ? onSubmit : null, label: submitLabel,
              color: canSubmit ? Palette.marigold : const Color(0xFFB9A57E)),
        ]),
      ]),
    );
  }
}
