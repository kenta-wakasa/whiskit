import 'package:flutter/material.dart';

import '/views/sign_in_button.dart';

class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          Text('ウィスキー選びをもっとおもしろく', style: textTheme.headline5),
          const SizedBox(height: 8),
          const Text('あなたにぴったりのウィスキーがきっと見つかる'),
          const Spacer(),
          SignInButton(),
          const Spacer(),
        ],
      ),
    );
  }
}
