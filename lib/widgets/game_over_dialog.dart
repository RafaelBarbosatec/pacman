import 'package:flutter/material.dart';
import 'package:pacman/util/game_state.dart';
import 'package:provider/provider.dart';

class GameOverDialog extends StatelessWidget {
  final GameState gameState;
  const GameOverDialog({Key? key, required this.gameState}) : super(key: key);

  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return  GameOverDialog(
          gameState: context.read(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.white);
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: textStyle.copyWith(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  overlayColor: WidgetStateProperty.all(
                    Colors.white.withOpacity(0.2),
                  ),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  gameState.reset();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/game',
                    (route) => false,
                  );
                },
                child: Text(
                  'Try again',
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
