import 'package:flutter/material.dart';

import '/views/sign_in_button.dart';

Widget signInWidget(TextTheme textTheme, double width) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: width, maxHeight: 200),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity),
        Text(
          'ウィスキー選びをもっとおもしろく',
          style: textTheme.headline5,
          maxLines: 1,
          textScaleFactor: width < 400 ? 0.8 : 1,
        ),
        const SizedBox(height: 8),
        const Text('あなたにぴったりのウィスキーがきっと見つかる'),
        const SizedBox(height: 32),
        SignInButton(),
        const Expanded(child: SizedBox()),
      ],
    ),
  );
}
