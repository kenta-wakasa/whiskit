import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/user_controller.dart';
import '/views/sing_in_widget.dart';
import '/views/utils/default_appbar.dart';
import '/views/whisky_list_widget.dart';

const basePadding = 8.0;

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const route = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(builder: (_, watch, __) {
                  watch(userProvider);
                  if (FirebaseAuth.instance.currentUser == null) {
                    return SignInWidget();
                  }
                  return const SizedBox();
                }),
                const WhiskyListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
