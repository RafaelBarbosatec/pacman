import 'package:flutter/material.dart';

class CongratulationsDialog extends StatelessWidget {
  const CongratulationsDialog({Key? key}) : super(key: key);

  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const CongratulationsDialog();
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
                'Congratulations!',
                style: textStyle.copyWith(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Thanks for testing this Bonfire game example.',
                style: textStyle,
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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                },
                child: Text(
                  'You are welcome',
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
