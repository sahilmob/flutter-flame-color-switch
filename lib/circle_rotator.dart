import 'dart:math';
import 'dart:async';
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
  }) : assert(size!.x == size!.y),
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
  }
}

class Arc extends PositionComponent with ParentIsA<CircleRotator> {
  final paint = Paint()..style = PaintingStyle.stroke;
  final double startAngle;
  final double sweepAngle;

  Arc({required color, required this.startAngle, required this.sweepAngle}) {
    paint.color = color;
    anchor = Anchor.center;
  }

  @override
  FutureOr<void> onLoad() {
    size = parent.size;
    position = size / 2;
    paint
      ..style
      ..strokeWidth = parent.thickness;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
    super.render(canvas);
  }
}
