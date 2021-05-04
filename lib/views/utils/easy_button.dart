import 'package:flutter/material.dart';

class EasyButton extends StatelessWidget {
  const EasyButton({
    required this.onPressed,
    required this.onPrimary,
    required this.primary,
    required this.text,
    this.padding = 0.0,
  });

  final Function()? onPressed;
  final Color? primary;
  final Color? onPrimary;
  final String text;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        height: 24,
        width: 80,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: primary,
            onPrimary: onPrimary,
            shape: const StadiumBorder(),
          ),
          child: SizedBox(
            height: 16,
            child: FittedBox(fit: BoxFit.fitHeight, child: Text(text)),
          ),
        ),
      ),
    );
  }
}
