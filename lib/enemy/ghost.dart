import 'package:bonfire/bonfire.dart';
import 'package:pacman/enemy/ghost_spritesheet.dart';
import 'package:pacman/main.dart';
import 'package:pacman/player/pacman_player.dart';

enum GhostType { red, blue, pink, orange }

class Ghost extends SimpleEnemy
    with ObjectCollision, AutomaticRandomMovement, Sensor {
  final GhostType type;
  bool runPowerMode = false;

  bool enabledBeheavor = false;
  Ghost({
    required super.position,
    this.type = GhostType.red,
  }) : super(
          size: Vector2.all(Game.tileSize),
          animation: GhostSpriteSheet.getByType(type),
          speed: 140,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: size - Vector2.all(4),
            align: Vector2.all(2),
          ),
        ],
      ),
    );

    setupSensorArea(areaSensor: [
      CollisionArea.rectangle(
        size: size - Vector2.all(10),
        align: Vector2.all(5),
      ),
    ]);
  }

  @override
  void update(double dt) {
    if ((gameRef.player as PacManPlayer?)?.withPower == true) {
      if (!runPowerMode) {
        runPowerMode = true;
        replaceAnimation(
          SimpleDirectionAnimation(
            idleRight: GhostSpriteSheet.runPower,
            runRight: GhostSpriteSheet.runPower,
            runUp: GhostSpriteSheet.runPower,
          ),
        );
        speed = 80;
      }
    } else if (runPowerMode) {
      speed = 140;
      runPowerMode = false;
      replaceAnimation(GhostSpriteSheet.getByType(type));
    }
    if (enabledBeheavor) {
      seePlayer(
        observed: (player) {
          if ((player as PacManPlayer).withPower) {
            seeAndMoveToAttackRange(
              positioned: (_) {},
              minDistanceFromPlayer: 48 * 3,
            );
          } else {
            seeAndMoveToPlayer(
              closePlayer: (player) {},
              margin: -5,
              radiusVision: 48 * 2,
            );
          }
        },
        radiusVision: 48 * 2,
        notObserved: () {
          _runRandom(dt);
        },
      );
    }
    super.update(dt);
  }

  void bite() {
    // enabledBeheavor = false;
    // enableCollision(false);
    removeFromParent();
  }

  _runRandom(double dt) {
    runRandomMovement(
      dt,
      speed: speed,
      maxDistance: 48 * 4,
      minDistance: 48 * 4,
      timeKeepStopped: 0,
    );
  }

  @override
  void onMount() {
    _startMovement();
    super.onMount();
  }

  void _startMovement() {
    Duration duration = Duration.zero;
    switch (type) {
      case GhostType.red:
        duration = const Duration(seconds: 1);
        break;
      case GhostType.blue:
        duration = const Duration(seconds: 6);
        break;
      case GhostType.pink:
        duration = const Duration(seconds: 11);
        break;
      case GhostType.orange:
        duration = const Duration(seconds: 16);
        break;
    }
    Future.delayed(duration, () {
      enabledBeheavor = true;
    });
  }

  @override
  void onContact(GameComponent component) {
    if (component is PacManPlayer) {
      if (component.withPower) {
        bite();
      } else {
        if (!component.isDead) {
          enabledBeheavor = false;
          component.idle();
          component.die();
        }
      }
    }
  }

  @override
  void onContactExit(GameComponent component) {}
}
