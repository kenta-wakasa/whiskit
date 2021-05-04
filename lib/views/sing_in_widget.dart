import 'package:flutter/material.dart';
import 'package:whiskit/views/utils/sign_in_button.dart';

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
          const Spacer(),
          SignInButton(),
          const Spacer(),
        ],
      ),
    );
  }
}
