import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/image_composition.dart';

import 'package:color_switch/game.dart';
import 'package:color_switch/star.dart';
import 'package:color_switch/ground.dart';
import 'package:color_switch/color_switcher.dart';
import 'package:color_switch/circle_rotator.dart';

class Player extends PositionComponent
    with KeyboardHandler, HasGameRef<ColorSwitchGame>, CollisionCallbacks {
  Player({this.playerRadius = 12, super.position});

  final _gravity = 980;
  final double playerRadius;
  final Paint _paint = Paint();
  final _velocity = Vector2.zero();

  Color _color = Colors.white;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    _paint.color = _color;
    size = Vector2.all(playerRadius * 2);
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += _velocity * dt;

    Ground? ground = game.findByKey(Ground.componentKey);

    if (ground != null &&
        positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      _velocity.setValues(0, 0);
      position.y = ground.position.y - height / 2;
    } else {
      _velocity.y += _gravity * dt;
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle((size / 2).toOffset(), playerRadius, _paint);
    super.render(canvas);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.logicalKey == LogicalKeyboardKey.space) {
      jump();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void jump() {
    _velocity.y = -350;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ColorSwitcher) {
      other.removeFromParent();
      _changeColorRandomly();
    } else if (other is Arc) {
      if (_color != other.color) {
        game.gameOver();
      }
    } else if (other is Star) {
      other.removeFromParent();
      game.increaseScore();
    }

    super.onCollision(intersectionPoints, other);
  }

  void _changeColorRandomly() {
    _color = gameRef.colors.random();
    _paint.color = _color;
  }
}
