import 'dart:math';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/particles.dart';
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

  void showCollectEffect() {
    final rnd = Random();
    Vector2 randomVec2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 80;

    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          lifespan: 1,
          count: 30,
          generator: (i) {
            return AcceleratedParticle(
              speed: randomVec2(),
              acceleration: randomVec2(),
              child: RotatingParticle(
                to: rnd.nextDouble() * pi * 2,
                child: ComputedParticle(
                  renderer: (canvas, particle) {
                    _starSprite.render(
                      canvas,
                      size: (size / 2) * (1 - particle.progress),
                      anchor: Anchor.center,
                      overridePaint:
                          Paint()
                            ..color = Colors.white10.withAlpha(
                              ((1 - particle.progress) * 100).floor(),
                            ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );

    removeFromParent();
  }
}
