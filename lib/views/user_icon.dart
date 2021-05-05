import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/views/home_page.dart';

class UserIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(userProvider);
    final user = controller.user;
    return InkWell(
      onTap: () {
        // サインインしていない
        if (controller.user == null) {
          // TODO: sign in をうながすダイアログを出すなど

        }
        // サインインしている
        else {
          Navigator.pushNamed(context, HomePage.route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: FittedBox(
            fit: BoxFit.fill,
            child: user == null
                ? const Icon(Icons.account_circle_rounded)
                : CircleAvatar(foregroundImage: NetworkImage(user.avatarUrl))),
      ),
    );
  }
}
