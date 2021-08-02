import 'dart:html';

import 'package:flutter/material.dart';
import 'package:whiskit/models/whisky.dart';

class EasyButton extends StatelessWidget {
  const EasyButton({
    required this.onPressed,
    required this.onPrimary,
    required this.primary,
    required this.text,
    this.padding = 0.0,
  });

  final GestureTapCallback? onPressed;
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
        width: 88,
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

Widget amazonButton(Whisky whisky) {
  return EasyButton(
    onPressed: whisky.amazon == '-' ? null : () => window.open(whisky.amazon, ''),
    primary: Colors.orangeAccent[700],
    onPrimary: Colors.white,
    text: 'Amazon',
  );
}

Widget rakutenButton(Whisky whisky) {
  return EasyButton(
    onPressed: whisky.rakuten == '-' ? null : () => window.open(whisky.rakuten, ''),
    primary: Colors.red,
    onPrimary: Colors.white,
    text: '楽天',
  );
}
