import 'package:bonfire/bonfire.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/player/custom_movement_by_joystick.dart';
import 'package:pacman/player/player_spritesheet.dart';

import '../main.dart';

class PacManPlayer extends SimplePlayer
    with ObjectCollision, CustomMovementByJoystick {
  bool withPower = false;
  bool youAreWinner = false;
  Future? _futurePowerTime;

  PacManPlayer({required super.position})
      : super(
          size: Vector2.all(Game.tileSize),
          animation: SimpleDirectionAnimation(
            idleRight: PlayerSpriteSheet.idle,
            runRight: PlayerSpriteSheet.runRight,
            runUp: PlayerSpriteSheet.runUp,
            runDown: PlayerSpriteSheet.runDown,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: size - Vector2.all(2),
            align: Vector2.all(1),
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    if (checkInterval('winner', 2000, dt) && !youAreWinner) {
      _checkIfWinenr();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    gameRef.camera.target = null;
    super.onMount();
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is Ghost) {
      return false;
    }
    return super.onCollision(component, active);
  }

  @override
  void die() {
    animation?.playOnce(
      PlayerSpriteSheet.die,
      onFinish: removeFromParent,
      runToTheEnd: true,
    );
    super.die();
  }

  void _checkIfWinenr() {
    bool winner = gameRef.componentsByType<Dot>().isEmpty;
    if (winner) {
      youAreWinner = true;
      print('PARABENS VC GANHOU !!');
    }
  }

  void startPower() {
    withPower = true;
    _futurePowerTime?.ignore();
    _futurePowerTime = Future.delayed(const Duration(seconds: 5), () {
      withPower = false;
    }).catchError(
      (e) {},
    );
  }
}
