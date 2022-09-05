import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/enemy/ghost_spritesheet.dart';
import 'package:pacman/player/pacman_spritesheet.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  Widget firstAnim = GhostSpriteSheet.runRightRed.asWidget();
  Widget secondAnim = PacManSpriteSheet.runRight.asWidget();

  bool withPower = false;
  late AnimationController _controller;
  late Animation<Offset> animation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    animation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: const Offset(1, 0),
    ).animate(_controller);
    _controller.addStatusListener(_statusListener);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 20);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PacMan',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 40),
                SlideTransition(
                  position: animation,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        firstAnim,
                        const SizedBox(width: 20),
                        secondAnim,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/game'),
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.2),
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Text(
                    'Start Game',
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Powered by Bonfire - Flutter',
                style: textStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (!withPower) {
        withPower = true;
        firstAnim = PacManSpriteSheet.runRight.asWidget();
        secondAnim = GhostSpriteSheet.runPower.asWidget();
      } else {
        withPower = false;
        secondAnim = PacManSpriteSheet.runRight.asWidget();
        switch (Random().nextInt(3)) {
          case 0:
            firstAnim = GhostSpriteSheet.runRightBlue.asWidget();
            break;
          case 1:
            firstAnim = GhostSpriteSheet.runRightBlue.asWidget();
            break;
          case 2:
            firstAnim = GhostSpriteSheet.runRightOrange.asWidget();
            break;
          case 3:
            firstAnim = GhostSpriteSheet.runRightPink.asWidget();
            break;
        }
      }
      setState(() {});
      _controller.forward(from: 0);
    }
  }
}
