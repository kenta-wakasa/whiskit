import 'package:flutter/material.dart';

class EasyButton extends StatelessWidget {
  const EasyButton({
    required this.onPressed,
    required this.onPrimary,
    required this.primary,
    required this.text,
  });
  final Function()? onPressed;
  final Color? primary;
  final Color? onPrimary;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 80,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(primary: primary, onPrimary: onPrimary, shape: const StadiumBorder()),
        child: SizedBox(
          height: 16,
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(text)),
        ),
      ),
    );
  }
}
