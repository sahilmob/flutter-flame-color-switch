import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Star extends PositionComponent {
  late Sprite _starSprite;

  Star({required super.position})
    : super(size: Vector2.all(28), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    add(CircleHitbox(radius: size.x / 2));
    _starSprite = await Sprite.load("star_icon.png");
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _starSprite.render(
      canvas,
      position: size / 2,
      size: size,
      anchor: Anchor.center,
    );
    super.render(canvas);
  }
}
