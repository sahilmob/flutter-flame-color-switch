import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  static var componentKey = ComponentKey.named("ground");
  Ground({required super.position})
    : super(size: Vector2(100, 1), anchor: Anchor.center, key: componentKey);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = Colors.red,
    );
    super.render(canvas);
  }
}
