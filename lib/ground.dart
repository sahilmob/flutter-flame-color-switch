import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  static var componentKey = ComponentKey.named("ground");
  Ground({required super.position})
    : super(size: Vector2(200, 2), anchor: Anchor.center, key: componentKey);

  late Sprite fingerSprite;

  @override
  FutureOr<void> onLoad() async {
    fingerSprite = await Sprite.load("finger_tap.png");
    // add(SpriteComponent(size: Vector2(100, 100), sprite: fingerSprite));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    fingerSprite.render(
      canvas,
      size: Vector2.all(100),
      position: Vector2(56, 0),
    );
    super.render(canvas);
  }
}
