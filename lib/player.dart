import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:color_switch/game.dart';
import 'package:color_switch/ground.dart';

class Player extends PositionComponent
    with KeyboardHandler, HasGameRef<ColorSwitchGame> {
  Player({this.playerRadius = 15, super.position});

  final _gravity = 980;
  final double playerRadius;
  final _velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2.all(playerRadius * 2);
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
    canvas.drawCircle(
      (size / 2).toOffset(),
      playerRadius,
      Paint()..color = Colors.amber,
    );
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
}
