import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

import 'package:color_switch/star.dart';
import 'package:color_switch/ground.dart';
import 'package:color_switch/player.dart';
import 'package:color_switch/circle_rotator.dart';
import 'package:color_switch/color_switcher.dart';

class ColorSwitchGame extends FlameGame
    with
        TapCallbacks,
        HasCollisionDetection,
        HasKeyboardHandlerComponents,
        HasDecorator,
        HasTimeScale {
  @override
  Color backgroundColor() => Color(0xff222222);
  late Player player;
  final List<Color> colors;
  ValueNotifier<int> score = ValueNotifier(0);

  ColorSwitchGame({
    this.colors = const [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
    ],
  }) : super(
         camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
       );

  @override
  FutureOr<void> onLoad() {
    decorator = PaintDecorator.blur(0.0);
    player = Player(position: Vector2(0, 250));
    _spawnObjects();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = player.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(
        camera.viewfinder.position.x,
        playerY,
      );
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    super.onTapDown(event);
  }

  void _spawnObjects() {
    world.add(ColorSwitcher(position: Vector2(0, 180)));
    world.add(CircleRotator(size: Vector2(200, 200), position: Vector2.zero()));
    world.add(Star(position: Vector2.zero()));
    world.add(ColorSwitcher(position: Vector2(0, -200)));
    world.add(
      CircleRotator(size: Vector2(150, 150), position: Vector2(0, -400)),
    );
    world.add(
      CircleRotator(size: Vector2(180, 180), position: Vector2(0, -400)),
    );
    world.add(Star(position: Vector2(0, -400)));
    world.add(player);
    world.add(Ground(position: Vector2(0, 400)));
  }

  void gameOver() {
    world.removeWhere((_) => true);
    player = Player(position: Vector2(0, 250));
    camera.moveTo(Vector2(0, 0));
    score.value = 0;
    _spawnObjects();
  }

  bool get isGamePaused => timeScale == 0;

  void pauseGame() {
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
  }

  void resumeGame() {
    (decorator as PaintDecorator).addBlur(0.0);
    timeScale = 1;
  }

  void increaseScore() {
    score.value++;
  }
}
