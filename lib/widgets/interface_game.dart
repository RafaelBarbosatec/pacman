import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/util_spritesheet.dart';

class InterfaceGame extends StatefulWidget {
  const InterfaceGame({Key? key}) : super(key: key);

  @override
  State<InterfaceGame> createState() => _InterfaceGameState();
}

class _InterfaceGameState extends State<InterfaceGame> {
  late GameState _state;
  final double sizeIcon = 20;

  @override
  void initState() {
    _state = BonfireInjector.instance.get();
    _state.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _state.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _state.score.toString(),
              style: textStyle,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(_state.lifes, (i) {
                return SizedBox(
                  width: sizeIcon,
                  height: sizeIcon,
                  child: UtilSpriteSheet.pacman.asWidget(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void _listener() {
    setState(() {});
  }
}
