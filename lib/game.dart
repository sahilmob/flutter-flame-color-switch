import 'dart:ui';
import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';

import 'package:color_switch/ground.dart';
import 'package:color_switch/player.dart';

class ColorSwitchGame extends FlameGame
    with TapCallbacks, HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => Color(0xff222222);
  late Player player;

  ColorSwitchGame()
    : super(
        camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
      );

  @override
  FutureOr<void> onLoad() {
    player = Player();
    world.add(player);
    world.add(Ground(position: Vector2(0, 200)));
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
}
