import 'dart:math';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';
import 'package:color_switch/game.dart';

class ColorSwitcher extends PositionComponent with HasGameRef<ColorSwitchGame> {
  final List<Paint> paints = [];
  ColorSwitcher({required super.position, this.radius = 20})
    : super(anchor: Anchor.center, size: Vector2.all(radius * 2));
  final double radius;

  @override
  FutureOr<void> onLoad() {
    for (var c in game.colors) {
      Paint paint = Paint();
      paint.color = c;
      paints.add(paint);
    }

    add(CircleHitbox(collisionType: CollisionType.passive));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    var sweep = (pi * 2) / paints.length;
    paints.asMap().forEach((i, p) {
      canvas.drawArc(size.toRect(), i * sweep, sweep, true, p);
    });
    super.render(canvas);
  }
}
