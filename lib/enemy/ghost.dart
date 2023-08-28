import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/enemy/ghost_spritesheet.dart';
import 'package:pacman/main.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/sounds.dart';

enum GhostType { red, blue, pink, orange }

enum GhostState { normal, vulnerable, die }

class Ghost extends SimpleEnemy
    with
        BlockMovementCollision,
        AutomaticRandomMovement,
        MoveToPositionAlongThePath {
  static const normalSpeed = 140.0;
  static const vulnerableSpeed = 90.0;
  static const dieSpeed = 240.0;
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
    setupMoveToPositionAlongThePath(
      pathLineColor: Colors.transparent,
    );
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: size / 1.5,
        position: size / 6,
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
    runRandomMovement(
      dt,
      speed: speed,
      maxDistance: (Game.tileSize * 4).toInt(),
      minDistance: (Game.tileSize * 4).toInt(),
      timeKeepStopped: 0,
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
    );

    speed = dieSpeed;
    moveToPositionAlongThePath(
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
    ].map((e) => e!.children.query<ShapeHitbox>().first).toList();
  }

  @override
  void onMount() {
    _gameState = BonfireInjector.instance.get();
    _gameState.listenChangePower(_pacManChangePower);
    _startInitialMovement();
    super.onMount();
  }

  void _startInitialMovement({bool withDelay = true}) async {
    switch (type) {
      case GhostType.red:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 1));
        }
        moveToPositionAlongThePath(
          Vector2(Game.tileSize * 4, Game.tileSize * 3),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.blue:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 6));
        }
        moveToPositionAlongThePath(
          Vector2(Game.tileSize * 14, Game.tileSize * 3),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.pink:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 11));
        }
        moveToPositionAlongThePath(
          Vector2(Game.tileSize * 4, Game.tileSize * 13),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.orange:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 16));
        }
        moveToPositionAlongThePath(
          Vector2(Game.tileSize * 14, Game.tileSize * 13),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
    }
  }

  void _removeEyeAnimation() {
    state = GhostState.normal;
    speed = normalSpeed;
    replaceAnimation(GhostSpriteSheet.getByType(type));
    _startInitialMovement(withDelay: false);
    if (_gameState.pacManWithPower) {
      Sounds.playPowerBackgroundSound();
    } else {
      Sounds.stopBackgroundSound();
    }
  }

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if (other is Dot || other is Ghost) {
      return false;
    }
    return super.onComponentTypeCheck(other);
  }

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    print(other);
    if (other is Tile) {
      _correctPositionToCenterTile();
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
      );
    } else if (state != GhostState.die) {
      state = GhostState.normal;
      speed = normalSpeed;
      replaceAnimation(GhostSpriteSheet.getByType(type));
    }
  }

  void _correctPositionToCenterTile() {
    int w = (position.x / Game.tileSize).round();
    int h = (position.y / Game.tileSize).round();
    position = Vector2(w * Game.tileSize, h * Game.tileSize);
  }
}
