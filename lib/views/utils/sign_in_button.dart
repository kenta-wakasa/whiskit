import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart' as button;
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/views/main_page.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return button.SignInButton(
      button.Buttons.Google,
      onPressed: () async {
        await context.read(userProvider).signInWithGoogle();
        await Navigator.pushNamed(context, MainPage.route);
      },
    );
  }
}
