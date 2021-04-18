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
    const basePadding = 8.0;
    final userCon = watch(userProvider);
    final userIcon = userCon.user == null
        ? const Icon(Icons.account_circle_rounded)
        : CircleAvatar(foregroundImage: NetworkImage(userCon.user!.avatarUrl!));
    final signIn = FirebaseAuth.instance.currentUser == null ? SignInWidget() : const SizedBox();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text('WHISKIT', style: textTheme.headline5)],
        ),
        actions: [
          InkWell(
            onTap: userCon.signOut,
            child: Container(
              padding: const EdgeInsets.all(basePadding),
              child: FittedBox(fit: BoxFit.fill, child: userIcon),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                signIn,
                const WhiskyListWidget(basePadding: basePadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
