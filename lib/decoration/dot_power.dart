import 'package:bonfire/bonfire.dart';
import 'package:avnetman/player/pacman.dart';
import 'package:avnetman/util/game_state.dart';
import 'package:avnetman/util/util_spritesheet.dart';

class DotPower extends GameDecoration with Sensor {
  bool givePower = false;
  late GameState _gameState;
  DotPower({
    required super.position,
  }) : super.withAnimation(
          animation: UtilSpriteSheet.dotPower,
          size: Vector2.all(48),
        ) {
    setupSensorArea(
      areaSensor: [
        CollisionArea.rectangle(
          size: Vector2.all(48),
          align: Vector2.all(1),
        ),
      ],
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is PacMan) {
      givePower = true;
      removeFromParent();
      _gameState.startPacManPower();
    }
  }

  @override
  void onMount() {
    _gameState = BonfireInjector.instance.get();
    super.onMount();
  }
}
