import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Buddy avatars a child can pick. Emoji for now; swap for drawn art later.
const buddies = ['🦁', '🐧', '🐻', '🦜', '🐰', '🦊'];

/// Scaffold with the soft lavender-to-peach background and a few sparkles.
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.body, this.appBar});
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Palette.bgTop, Palette.bgBottom],
        ),
      ),
      child: CustomPaint(
        painter: _SparklePainter(),
        child: Scaffold(backgroundColor: Colors.transparent, appBar: appBar, body: body),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  static const _spots = [
    (0.08, 0.06, 5.0, Palette.sun), (0.9, 0.12, 4.0, Palette.violet),
    (0.82, 0.38, 3.0, Palette.pink), (0.05, 0.5, 3.5, Palette.sky),
    (0.93, 0.7, 4.5, Palette.sun), (0.12, 0.88, 3.0, Palette.violet),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final (x, y, r, c) in _spots) {
      final p = Paint()..color = c.withValues(alpha: 0.35);
      final o = Offset(x * size.width, y * size.height);
      final path = Path()
        ..moveTo(o.dx, o.dy - r * 2)
        ..quadraticBezierTo(o.dx, o.dy, o.dx + r * 2, o.dy)
        ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy + r * 2)
        ..quadraticBezierTo(o.dx, o.dy, o.dx - r * 2, o.dy)
        ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy - r * 2);
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => false;
}

/// White rounded card with a soft shadow; tappable when [onTap] is set.
class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.color = Palette.surface, this.radius = 28});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Pastel tile with a bold symbol, used for skills and tricks.
class SymbolTile extends StatelessWidget {
  const SymbolTile(this.symbol, {super.key, required this.color, this.size = 64});
  final String symbol;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          child: Text(symbol,
              textDirection: TextDirection.ltr,
              style: rubik(size * 0.42, weight: FontWeight.w800, color: Color.lerp(color, Palette.ink, 0.25))),
        ),
      ),
    );
  }
}

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
        color: selected ? Palette.lilac : Colors.white,
        shape: BoxShape.circle,
        boxShadow: softShadow,
        border: Border.all(color: selected ? Palette.violet : Colors.white, width: size * 0.05),
      ),
      child: Text(buddies[id % buddies.length], style: TextStyle(fontSize: size * 0.48)),
    );
  }
}

/// Otto's speech bubble.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.text, {super.key, this.size = 21});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: softShadow,
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: rubik(size, weight: FontWeight.w600, height: 1.3)),
    );
  }
}

class StarRow extends StatelessWidget {
  const StarRow(this.stars, {super.key, this.size = 20, this.max = 3});
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
            Icon(Icons.star_rounded,
                size: size, color: i < stars ? Palette.sun : Palette.lilac),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: softShadow),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.toll_rounded, color: Palette.sun, size: 22),
        const SizedBox(width: 6),
        Text('$coins', style: rubik(18, weight: FontWeight.w700)),
      ]),
    );
  }
}

/// Thin rounded progress bar.
class SoftProgress extends StatelessWidget {
  const SoftProgress(this.value, {super.key});
  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 10,
        color: Palette.violet,
        backgroundColor: Palette.lilac,
      ),
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
    Widget key(Widget child, VoidCallback? onTap, {required String label, Color color = Colors.white}) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Semantics(
              button: true,
              label: label,
              excludeSemantics: true,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x125A3FD1), blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onTap,
                    child: SizedBox(height: 58, child: Center(child: child)),
                  ),
                ),
              ),
            ),
          ),
        );
    Widget digit(int d) =>
        key(Text('$d', style: rubik(28, weight: FontWeight.w700)), () => onDigit(d), label: '$d');

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (final row in const [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          Row(children: [for (final d in row) digit(d)]),
        Row(children: [
          key(const Icon(Icons.backspace_rounded, color: Palette.inkSoft, size: 26), onBackspace,
              label: '⌫'),
          digit(0),
          key(Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(child: Text(submitLabel, style: rubik(20, weight: FontWeight.w700, color: Colors.white))),
              ),
              canSubmit ? onSubmit : null,
              label: submitLabel,
              color: canSubmit ? Palette.violet : Palette.violet.withValues(alpha: 0.35)),
        ]),
      ]),
    );
  }
}

/// Section heading with an icon.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, this.icon, {super.key, this.color = Palette.violet});
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: rubik(20, weight: FontWeight.w700))),
        ]),
      );
}

/// Big equation text that always reads left-to-right.
class Equation extends StatelessWidget {
  const Equation(this.text, {super.key, this.size = 48, this.color = Palette.ink});
  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: rubik(size, weight: FontWeight.w800, color: color)),
        ),
      );
}
