import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '/controllers/user_controller.dart';

class SignInWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(userProvider);
    return SignInButton(Buttons.Google, onPressed: provider.signInWithGoogle);
  }
}
