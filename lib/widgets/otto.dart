import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Placeholder Otto: a small purple octopus in a star-spangled top hat,
/// drawn in code until real art exists. [balls] juggling balls float above.
class Otto extends StatefulWidget {
  const Otto({super.key, this.size = 160, this.balls = 0, this.mood = OttoMood.happy});

  final double size;
  final int balls;
  final OttoMood mood;

  @override
  State<Otto> createState() => _OttoState();
}

enum OttoMood { happy, thinking, cheering, eyesClosed }

class _OttoState extends State<Otto> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduce Motion: respect the system "remove animations" setting.
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Otto',
      image: true,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => CustomPaint(
            size: Size(widget.size, widget.size * (widget.balls > 0 ? 1.45 : 1.15)),
            painter: _OttoPainter(_c.value, widget.balls, widget.mood),
          ),
        ),
      ),
    );
  }
}

class _OttoPainter extends CustomPainter {
  _OttoPainter(this.t, this.balls, this.mood);
  final double t;
  final int balls;
  final OttoMood mood;

  static const _ballColors = [
    Palette.sun, Palette.mint, Palette.coral, Palette.sky,
    Palette.pink, Palette.violet, Color(0xFF9BE07A), Color(0xFFFFD86B),
  ];
  static const _bodyLight = Color(0xFFA38BFF);
  static const _armDark = Color(0xFF6A4BE0);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final bob = sin(t * 2 * pi) * w * 0.02;
    final top = balls > 0 ? w * 0.3 : 0.0;
    final cx = w / 2;
    final headY = top + w * 0.52 + bob;
    final r = w * 0.27;

    // Juggling balls in an arc over the hat.
    for (var i = 0; i < balls; i++) {
      final phase = (t + i / max(balls, 1)) % 1.0;
      final angle = pi + phase * pi; // left to right over the top
      final bx = cx + cos(angle) * w * 0.42;
      final by = top + w * 0.18 + sin(angle) * w * 0.32 + w * 0.02;
      canvas.drawCircle(Offset(bx, by), w * 0.055,
          Paint()..color = _ballColors[i % _ballColors.length]);
    }

    // Soft shadow on the floor.
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, headY + r * 1.62), width: w * 0.7, height: w * 0.07),
        Paint()..color = Palette.violetDeep.withValues(alpha: 0.12));

    final body = Paint()..color = Palette.violet;
    final bodyDark = Paint()..color = _armDark;

    // Eight wavy arms.
    for (var i = 0; i < 8; i++) {
      final spread = (i - 3.5) / 3.5; // -1..1
      final path = Path();
      final startX = cx + spread * r * 0.8;
      final startY = headY + r * 0.55;
      final wave = sin(t * 2 * pi + i) * w * 0.03;
      final endX = cx + spread * w * 0.46 + wave;
      final endY = headY + r * 1.45 + (1 - spread.abs()) * w * 0.05;
      path.moveTo(startX - w * 0.035, startY);
      path.quadraticBezierTo(
          (startX + endX) / 2 + wave, (startY + endY) / 2 + w * 0.03, endX, endY);
      path.quadraticBezierTo((startX + endX) / 2 + wave + w * 0.05,
          (startY + endY) / 2, startX + w * 0.035, startY);
      path.close();
      canvas.drawPath(path, i.isEven ? body : bodyDark);
      canvas.drawCircle(Offset(endX, endY), w * 0.022, i.isEven ? body : bodyDark);
    }

    // Head with a soft highlight.
    final headRect = Rect.fromCenter(center: Offset(cx, headY), width: r * 2.1, height: r * 1.9);
    canvas.drawOval(
        headRect,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.35, -0.45),
            radius: 0.9,
            colors: [_bodyLight, Palette.violet],
          ).createShader(headRect));
    // Cheeks.
    final cheek = Paint()..color = Palette.pink.withValues(alpha: 0.55);
    canvas.drawCircle(Offset(cx - r * 0.62, headY + r * 0.28), r * 0.14, cheek);
    canvas.drawCircle(Offset(cx + r * 0.62, headY + r * 0.28), r * 0.14, cheek);

    // Eyes (blink now and then).
    final blink = (t > 0.92 && t < 0.97);
    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = Palette.ink;
    for (final dx in [-0.36, 0.36]) {
      final c = Offset(cx + r * dx, headY - r * 0.02);
      if (mood == OttoMood.eyesClosed) {
        canvas.drawArc(Rect.fromCenter(center: c, width: r * 0.36, height: r * 0.26), pi, pi, false,
            Paint()
              ..color = Palette.ink
              ..style = PaintingStyle.stroke
              ..strokeWidth = w * 0.016
              ..strokeCap = StrokeCap.round);
      } else if (blink) {
        canvas.drawLine(c.translate(-r * 0.16, 0), c.translate(r * 0.16, 0),
            pupil..strokeWidth = w * 0.015);
      } else {
        canvas.drawOval(Rect.fromCenter(center: c, width: r * 0.42, height: r * 0.5), white);
        final look = mood == OttoMood.thinking ? Offset(r * 0.06, -r * 0.08) : Offset.zero;
        canvas.drawCircle(c + look, r * 0.12, pupil);
        canvas.drawCircle(c + look + Offset(r * 0.04, -r * 0.05), r * 0.04, white);
      }
    }

    // Mouth.
    final mouth = Paint()
      ..color = Palette.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round;
    final mouthRect =
        Rect.fromCenter(center: Offset(cx, headY + r * 0.3), width: r * 0.6, height: r * 0.4);
    if (mood == OttoMood.cheering) {
      canvas.drawArc(mouthRect, 0, pi, true, Paint()..color = Palette.ink);
    } else if (mood == OttoMood.thinking) {
      canvas.drawLine(Offset(cx - r * 0.15, headY + r * 0.42),
          Offset(cx + r * 0.15, headY + r * 0.38), mouth);
    } else {
      canvas.drawArc(mouthRect, 0.2, pi - 0.4, false, mouth);
    }

    // Top hat with a marigold band and stars.
    final hatW = r * 1.25, hatH = r * 1.0;
    final hatBottom = headY - r * 0.78;
    final tilt = -0.12;
    canvas.save();
    canvas.translate(cx + r * 0.15, hatBottom);
    canvas.rotate(tilt);
    final hat = Paint()..color = Palette.ink;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-hatW * 0.85, -r * 0.08, hatW * 1.7, r * 0.16), Radius.circular(r * 0.08)),
        hat);
    canvas.drawRect(Rect.fromLTWH(-hatW / 2, -hatH, hatW, hatH), hat);
    canvas.drawRect(Rect.fromLTWH(-hatW / 2, -r * 0.3, hatW, r * 0.18),
        Paint()..color = Palette.sun);
    _star(canvas, Offset(-hatW * 0.18, -hatH * 0.62), r * 0.11);
    _star(canvas, Offset(hatW * 0.22, -hatH * 0.8), r * 0.07);
    canvas.restore();
  }

  void _star(Canvas canvas, Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final rr = i.isEven ? r : r * 0.45;
      final a = -pi / 2 + i * pi / 5;
      final p = c + Offset(cos(a) * rr, sin(a) * rr);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = Palette.sun);
  }

  @override
  bool shouldRepaint(_OttoPainter old) =>
      old.t != t || old.balls != balls || old.mood != mood;
}
