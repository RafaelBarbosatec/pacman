import 'package:bonfire/bonfire.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/player/custom_movement_by_joystick.dart';
import 'package:pacman/player/pacman_spritesheet.dart';

import '../main.dart';

class PacMan extends SimplePlayer
    with ObjectCollision, CustomMovementByJoystick {
  bool youAreWinner = false;

  PacMan({required super.position})
      : super(
          size: Vector2.all(Game.tileSize),
          animation: SimpleDirectionAnimation(
            idleRight: PacManSpriteSheet.idle,
            runRight: PacManSpriteSheet.runRight,
            runUp: PacManSpriteSheet.runUp,
            enabledFlipY: true
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
      PacManSpriteSheet.die,
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
}
