// Renders Otto to PNG for the app icon. Run: flutter test tool/render_icon_test.dart
// Output: build/icon/otto.png (1024 x 1024, transparent background).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_tricksters/widgets/otto.dart';

void main() {
  test('render Otto icon', () async {
    const size = 1024.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    // Otto's painter is drawn in a box 1.15x taller than wide; centre it.
    const w = size * 0.86;
    canvas.translate((size - w) / 2, size * 0.02);
    OttoPainter(0.25, 0, OttoMood.happy, floorShadow: false).paint(canvas, const Size(w, w * 1.15));
    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory('build/icon').createSync(recursive: true);
    File('build/icon/otto.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}
