import 'package:bonfire/bonfire.dart';
import 'package:pacman/main.dart';
import 'package:pacman/util/util_spritesheet.dart';

class EatScore extends GameDecoration with Movement, HandleForces {
  EatScore({
    required super.position,
  }) : super.withSprite(
          size: Vector2.all(Game.tileSize),
          sprite: UtilSpriteSheet.score100,
        ) {
    speed = 140;
    renderAboveComponents = true;
    addForce(
      ResistanceForce2D(
        id: 1,
        value: Vector2(4, 4),
      ),
    );
  }

  @override
  void update(double dt) {
    if (velocity.y.abs() < 5 && !isRemoving) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    super.onMount();
    moveUp();
  }
}
