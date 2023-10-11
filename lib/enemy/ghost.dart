import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/decoration/dot_power.dart';
import 'package:pacman/enemy/ghost_spritesheet.dart';
import 'package:pacman/main.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/sounds.dart';

enum GhostType { red, blue, pink, orange }

enum GhostState { normal, vulnerable, die }

class Ghost extends SimpleEnemy
    with BlockMovementCollision, AutomaticRandomMovement, PathFinding {
  static const normalSpeed = 100.0;
  static const vulnerableSpeed = 90.0;
  static const dieSpeed = 200.0;
  GhostState state = GhostState.normal;
  final Vector2 _startPositionAfterDie = Vector2(
    Game.tileSize * 9,
    Game.tileSize * 9,
  );
  late GameState _gameState;
  final GhostType type;

  bool enabledBeheavor = false;
  Ghost({
    required super.position,
    this.type = GhostType.red,
  }) : super(
          size: Vector2.all(Game.tileSize),
          animation: GhostSpriteSheet.getByType(type),
          speed: normalSpeed,
        ) {
    setupPathFinding(
      // pathLineColor: Colors.transparent,
      showBarriersCalculated: true,
    );
  }

  @override
  Future<void> onLoad() {
    final s = size * 0.7;
    add(
      RectangleHitbox(
        size: s,
        position: (size - s) / 2,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (enabledBeheavor && !isMovingAlongThePath) {
      seePlayer(
        observed: (player) {
          if (state == GhostState.vulnerable) {
            positionsItselfAndKeepDistance(
              player,
              minDistanceFromPlayer: Game.tileSize * 3,
            );
          } else {
            moveTowardsTarget(
              target: player,
              margin: -10,
            );
          }
        },
        radiusVision: Game.tileSize * 2,
        notObserved: () => _runRandom(dt),
      );
    }
    super.update(dt);
  }

  void _runRandom(double dt) {
    int randomDistance = Random().nextBool() ? 2 : 4;
    runRandomMovement(
      dt,
      speed: speed,
      maxDistance: (Game.tileSize * randomDistance).toInt(),
      minDistance: (Game.tileSize * randomDistance).toInt(),
      timeKeepStopped: 0,
      direction: RandomMovementDirectionEnum.horizontallyOrvertically,
    );
  }

  void bite() {
    state = GhostState.die;
    enabledBeheavor = false;
    final animation = GhostSpriteSheet.runEyes;
    replaceAnimation(
      SimpleDirectionAnimation(
        idleRight: animation,
        runRight: animation,
      ),
      doIdle: false,
    );
    speed = dieSpeed;
    moveToPositionWithPathFinding(
      _startPositionAfterDie,
      ignoreCollisions: ignoreableCollisions,
      onFinish: _removeEyeAnimation,
    );
    Sounds.eatGhost();
    Sounds.playRetreatingBackgroundSound();
  }

  List<dynamic> get ignoreableCollisions {
    return [
      gameRef.player,
      ...gameRef.enemies(),
      ...gameRef.query<Dot>(),
      ...gameRef.query<DotPower>(),
    ].map((e) => e!.children.query<ShapeHitbox>().first).toList();
  }

  @override
  void onMount() {
    _gameState = GameState();
    _gameState.listenChangePower(_pacManChangePower);
    _startInitialMovement();
    super.onMount();
  }

  void _startInitialMovement({bool withDelay = true}) async {
    const half = Game.tileSize / 2;
    switch (type) {
      case GhostType.red:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 1));
        }
        moveToPositionWithPathFinding(
          Vector2((Game.tileSize * 4) + half, (Game.tileSize * 3) + half),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.blue:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 6));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 14 + half, Game.tileSize * 3 + half),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.pink:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 11));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 4 + half, Game.tileSize * 13 + half),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.orange:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 16));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 14 + half, Game.tileSize * 13 + half),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
    }
  }

  void _removeEyeAnimation() {
    replaceAnimation(GhostSpriteSheet.getByType(type), doIdle: false);
    _startInitialMovement(withDelay: false);
    if (_gameState.pacManWithPower) {
      Sounds.playPowerBackgroundSound();
    } else {
      Sounds.stopBackgroundSound();
    }
    state = GhostState.normal;
    speed = normalSpeed;
  }

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    if (other is Dot || other is Ghost || state == GhostState.die) {
      return false;
    }
    return super.onBlockMovement(intersectionPoints, other);
  }

  void _pacManChangePower(bool value) {
    if (value) {
      state = GhostState.vulnerable;
      speed = vulnerableSpeed;
      final animation = GhostSpriteSheet.runPower;
      replaceAnimation(
        SimpleDirectionAnimation(
          idleRight: animation,
          runRight: animation,
        ),
        doIdle: false,
      );
    } else if (state != GhostState.die) {
      state = GhostState.normal;
      speed = normalSpeed;
      replaceAnimation(
        GhostSpriteSheet.getByType(type),
        doIdle: false,
      );
    }
  }

  @override
  void stopMove({bool forceIdle = false, bool isX = true, bool isY = true}) {
    _correctPositionToCenterTile();
    super.stopMove(forceIdle: forceIdle, isX: isX, isY: isY);
  }

  void _correctPositionToCenterTile() {
    int w = (position.x / Game.tileSize).round();
    int h = (position.y / Game.tileSize).round();
    position = Vector2(w * Game.tileSize, h * Game.tileSize);
  }
}
