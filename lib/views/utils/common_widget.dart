import 'package:flutter/material.dart';

Widget progressIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );
}
