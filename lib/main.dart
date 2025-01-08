import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/decoration/dot_power.dart';
import 'package:pacman/decoration/sensor_gate.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/menu.dart';
import 'package:pacman/player/pacman.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/sounds.dart';
import 'package:pacman/widgets/interface_game.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Sounds.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const MenuPage(),
        '/game': (_) => const Game(),
      },
    );
  }
}

class Game extends StatefulWidget {
  static const double heightMap = 1004.0;
  static const double tileSize = 48.0;
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    double size = min(sizeScreen.width, sizeScreen.height);

    return Container(
      color: Colors.black,
      child: FadeTransition(
        opacity: _controller,
        child: ListenableProvider(
          create: (context) => GameState(),
          child: Center(
            child: SizedBox(
              width: size,
              height: size,
              child: BonfireWidget(
                map: WorldMapByTiled(
                  WorldMapReader.fromAsset('map.tmj'),
                  objectsBuilder: {
                    'sensor_left': (properties) => SensorGate(
                          position: properties.position,
                          direction: DiractionGate.left,
                        ),
                    'sensor_right': (properties) => SensorGate(
                          position: properties.position,
                          direction: DiractionGate.right,
                        ),
                    'dot': (properties) => Dot(
                          position: properties.position,
                        ),
                    'dot_power': (properties) => DotPower(
                          position: properties.position,
                        ),
                    'ghost_red': (properties) => Ghost(
                          position: properties.position,
                          type: GhostType.red,
                        ),
                    'ghost_pink': (properties) => Ghost(
                          position: properties.position,
                          type: GhostType.pink,
                        ),
                    'ghost_orange': (properties) => Ghost(
                          position: properties.position,
                          type: GhostType.orange,
                        ),
                    'ghost_blue': (properties) => Ghost(
                          position: properties.position,
                          type: GhostType.blue,
                        ),
                  },
                ),
                playerControllers: [
                  Keyboard(),
                ],
                overlayBuilderMap: {
                  'score': ((context, game) => const InterfaceGame()),
                },
                initialActiveOverlays: const ['score'],
                cameraConfig: CameraConfig(
                  initialMapZoomFit: InitialMapZoomFitEnum.fit,
                  startFollowPlayer: false,
                  moveOnlyMapArea: true,
                ),
                player: PacMan(
                  position: PacMan.initialPosition,
                ),
                onReady: (_) {
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () => _controller.forward(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
