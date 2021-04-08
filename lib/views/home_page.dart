import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/user_controller.dart';
import '/views/sign_in_widget.dart';
import '/views/whisky_list_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = '/';
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final textTheme = Theme.of(context).textTheme;
    final userCon = watch(userProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final maxLength = max(width, height);
    final basePadding = maxLength / 40;
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
              child: FittedBox(
                fit: BoxFit.fill,
                child: userCon.user?.avatarUrl == null
                    ? const Icon(Icons.account_circle_rounded)
                    : CircleAvatar(
                        foregroundImage: NetworkImage(userCon.user!.avatarUrl!),
                      ),
              ),
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
                userCon.user?.id != null
                    ? const SizedBox()
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320, maxHeight: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ウィスキーをもっとおもしろく',
                              style: textTheme.headline5,
                              maxLines: 1,
                              textScaleFactor: width < 400 ? 0.8 : 1,
                            ),
                            const SizedBox(height: 8),
                            const Text('まだ飲んだことのないあなたにぴったりのウィスキーがきっと見つかる'),
                            const SizedBox(height: 32),
                            SignInWidget(),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                WhiskyListWidget(key: UniqueKey()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
