import 'package:bonfire/bonfire.dart';
import 'package:pacman/player/pacman_player.dart';
import 'package:pacman/util_spritesheet.dart';

class DotPower extends GameDecoration with Sensor {
  bool givePower = false;
  DotPower({
    required super.position,
  }) : super.withAnimation(
          animation: UtilSpriteSheet.dotPower,
          size: Vector2.all(18),
        ) {
    setupSensorArea(
      areaSensor: [
        CollisionArea.rectangle(
          size: Vector2.all(16),
          align: Vector2.all(2),
        ),
      ],
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is PacManPlayer) {
      if (!givePower) {
        givePower = true;
        removeFromParent();
        component.startPower();
      }
    }
  }

  @override
  void onContactExit(GameComponent component) {
  }
}
