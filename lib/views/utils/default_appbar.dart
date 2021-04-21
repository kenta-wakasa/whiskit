import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/views/home_page.dart';

import '/controllers/user_controller.dart';
import '/views/main_page.dart';

AppBar defaultAppBar({required BuildContext context}) {
  final textTheme = Theme.of(context).textTheme;
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Text('WHISKIT', style: textTheme.headline5)],
    ),
    actions: [
      InkWell(
        onTap: () {
          // サインインしていない
          if (context.read(userProvider).user == null) {
          }
          // サインインしている
          else {
            Navigator.pushNamed(context, HomePage.route);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(basePadding),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Consumer(
              builder: (_, watch, __) {
                final user = watch(userProvider).user;
                if (user == null) {
                  return const Icon(Icons.account_circle_rounded);
                }
                return CircleAvatar(foregroundImage: NetworkImage(user.avatarUrl!));
              },
            ),
          ),
        ),
      ),
    ],
  );
}
