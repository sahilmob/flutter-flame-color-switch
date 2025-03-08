import 'dart:math';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'package:color_switch/game.dart';

class CircleRotator extends PositionComponent with HasGameRef<ColorSwitchGame> {
  CircleRotator({
    this.thickness = 8,
    required super.size,
    required super.position,
    this.rotationSpeed = 1,
  }) : assert(size!.x == size.y),
       super(anchor: Anchor.center);
  final double thickness;
  final double rotationSpeed;

  @override
  void onLoad() {
    final sweep = ((pi * 2) / game.colors.length);
    game.colors.asMap().forEach((i, c) {
      add(Arc(color: c, startAngle: sweep * i, sweepAngle: sweep));
    });

    add(
      RotateEffect.to(
        pi * 2,
        EffectController(speed: rotationSpeed, infinite: true),
      ),
    );
    super.onLoad();
  }
}

class Arc extends PositionComponent with ParentIsA<CircleRotator> {
  final _paint = Paint()..style = PaintingStyle.stroke;
  final Color color;
  final double _startAngle;
  final double _sweepAngle;

  Arc({
    required this.color,
    required double startAngle,
    required double sweepAngle,
  }) : _sweepAngle = sweepAngle,
       _startAngle = startAngle {
    _paint.color = color;
    anchor = Anchor.center;
  }

  @override
  FutureOr<void> onLoad() {
    size = parent.size;
    position = size / 2;
    _paint
      ..style
      ..strokeWidth = parent.thickness;
    _addHitbox();
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      _startAngle,
      _sweepAngle,
      false,
      _paint,
    );
    super.render(canvas);
  }

  void _addHitbox() {
    const precision = 8;
    final center = size / 2;
    final segment = _sweepAngle / (precision - 1);
    final radius = size.x / 2;

    List<Vector2> vertices = [];

    for (int i = 0; i < precision; i++) {
      final thisSegment = _startAngle + segment * i;
      vertices.add(
        center + Vector2(cos(thisSegment), sin(thisSegment)) * radius,
      );
    }

    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = _startAngle + segment * i;
      vertices.add(
        center +
            Vector2(cos(thisSegment), sin(thisSegment)) *
                (radius - parent.thickness),
      );
    }

    add(PolygonHitbox(vertices, collisionType: CollisionType.passive));
  }
}
