import 'package:bonfire/bonfire.dart';
import 'package:pacman/main.dart';
import 'package:pacman/util/util_spritesheet.dart';

class EatScore extends GameDecoration with Movement, Acceleration {
  EatScore({
    required super.position,
  }) : super.withSprite(
          size: Vector2.all(Game.tileSize),
          sprite: UtilSpriteSheet.score100,
        ) {
    speed = 140;
    aboveComponents = true;
  }

  @override
  void update(double dt) {
    if (speed == 0 && !isRemoving) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    applyAccelerationByDirection(-4, Direction.up, stopWhenSpeedZero: true);
    super.onMount();
  }
}
