import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/views/main_page.dart';

import '/controllers/user_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = '/home';
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, MainPage.route);
              },
              child: Text('WHISKIT', style: textTheme.headline5),
            )
          ],
        ),
      ),
      body: Center(child: Consumer(builder: (_, watch, __) {
        final user = watch(userProvider).user;
        final name = user?.name ?? '-';
        return Text(name);
      })),
    );
  }
}
