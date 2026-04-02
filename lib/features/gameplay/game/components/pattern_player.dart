import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PatternPlayer extends PositionComponent {
  int _totalSteps = 0;
  int _matchedSteps = 0;

  void loadPattern(int totalSteps) {
    _totalSteps = totalSteps;
    _matchedSteps = 0;
  }

  void updateProgress(int matchedSteps) {
    _matchedSteps = matchedSteps;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_totalSteps == 0) {
      return;
    }

    final Paint inactivePaint = Paint()
      ..color = const Color(0xFF12324C)
      ..style = PaintingStyle.fill;
    final Paint activePaint = Paint()
      ..color = const Color(0xFF4CF7FF)
      ..style = PaintingStyle.fill;

    const double gap = 8;
    final double segmentWidth =
        ((size.x - ((_totalSteps - 1) * gap)) / _totalSteps).clamp(8, 64);

    for (int index = 0; index < _totalSteps; index += 1) {
      final Rect rect = Rect.fromLTWH(
        index * (segmentWidth + gap),
        0,
        segmentWidth,
        size.y,
      );
      final RRect segment = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(12),
      );
      canvas.drawRRect(
        segment,
        index < _matchedSteps ? activePaint : inactivePaint,
      );
    }
  }
}
