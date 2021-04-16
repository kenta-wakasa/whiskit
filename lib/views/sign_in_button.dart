import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart' as button;

import '/controllers/user_controller.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return button.SignInButton(
      button.Buttons.Google,
      onPressed: context.read(userProvider).signInWithGoogle,
    );
  }
}
