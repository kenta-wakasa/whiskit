import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/user_controller.dart';
import '/views/sing_in_widget.dart';
import '/views/whisky_list_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = '/';
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final maxLength = max(width, height);
    final basePadding = maxLength / 80;
    final userCon = watch(userProvider);
    final userIcon = userCon.user == null
        ? const Icon(Icons.account_circle_rounded)
        : CircleAvatar(foregroundImage: NetworkImage(userCon.user!.avatarUrl!));
    final signIn = userCon.user == null ? signInWidget(textTheme, width) : const SizedBox();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text('WHISKIT', style: textTheme.headline5)],
        ),
        actions: [
          InkWell(
            onTap: userCon.signOut,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: FittedBox(fit: BoxFit.fill, child: userIcon),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                signIn,
                WhiskyListWidget(
                  basePadding: basePadding,
                  maxLength: maxLength,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
