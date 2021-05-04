import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/whisky.dart';
import 'package:whiskit/models/whisky_log.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/utils/easy_button.dart';

import '/controllers/user_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = '/home';
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider).user;
    final name = user?.name ?? '-';
    final textTheme = Theme.of(context).textTheme;
    if (user == null) {
      return const SizedBox();
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, MainPage.route),
              child: Text('WHISKIT', style: textTheme.headline5),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(foregroundImage: NetworkImage(user.avatarUrl)),
            EasyButton(
              onPressed: () {
                Navigator.pushNamed(context, MainPage.route);
                context.read(userProvider).signOut();
              },
              onPrimary: Theme.of(context).scaffoldBackgroundColor,
              primary: Colors.white,
              text: 'サインアウト',
            ),
            Text(name),
            FutureBuilder(
              future: WhiskyLogRepository.fetchWhiskyLogListByUser(user),
              builder: (context, AsyncSnapshot<List<Whisky>> asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final whiskyList = asyncSnapshot.data;
                // データがない
                if (whiskyList == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: whiskyList.length,
                    itemBuilder: (context, index) {
                      final whisky = whiskyList[index];
                      return ListTile(title: Text(whisky.name));
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
