import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

typedef TileTapCallback = void Function(int tileId);

class TileComponent extends PositionComponent with TapCallbacks {
  TileComponent({
    required this.tileId,
    required this.label,
    required this.onTileTapped,
  });

  final int tileId;
  final String label;
  final TileTapCallback onTileTapped;

  final TextPaint _textPaint = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.w700,
    ),
  );

  bool _isHighlighted = false;
  bool _isPressed = false;
  Color? _flashColor;

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox());
  }

  void setHighlighted(bool value) {
    if (_isHighlighted == value) {
      return;
    }

    _isHighlighted = value;
  }

  void flash({required bool success}) {
    _flashColor = success ? const Color(0xFF6BFF9D) : const Color(0xFFFF6FDB);
    Future<void>.delayed(const Duration(milliseconds: 180), () {
      if (isMounted) {
        _flashColor = null;
      }
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isPressed = true;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _isPressed = false;
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isPressed = false;
    onTileTapped(tileId);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Color baseColor = _isHighlighted
        ? const Color(0xFF124E6B)
        : const Color(0xFF102236);
    final Color borderColor =
        _flashColor ??
        (_isHighlighted ? const Color(0xFF4CF7FF) : const Color(0xFF224B6D));

    final RRect tile = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(24),
    );

    final Paint fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          _isPressed ? baseColor.withValues(alpha: 0.85) : baseColor,
          const Color(0xFF07111F),
        ],
      ).createShader(Offset.zero & Size(size.x, size.y));

    final Paint border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _isHighlighted ? 4 : 2;

    canvas.drawRRect(tile, fill);
    canvas.drawRRect(tile, border);

    _textPaint.render(
      canvas,
      label,
      Vector2((size.x / 2) - 10, (size.y / 2) - 18),
      anchor: Anchor.topLeft,
    );
  }
}
