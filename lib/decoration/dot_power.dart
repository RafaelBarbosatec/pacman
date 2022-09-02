import 'package:bonfire/bonfire.dart';
import 'package:pacman/player/pacman.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/util_spritesheet.dart';

class DotPower extends GameDecoration with Sensor {
  bool givePower = false;
  late GameState _gameState;
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
    if (component is PacMan) {
      if (!givePower) {
        givePower = true;
        removeFromParent();
        _gameState.startPacManPower();
      }
    }
  }

  @override
  void onMount() {
    _gameState = BonfireInjector.instance.get();
    super.onMount();
  }
}
