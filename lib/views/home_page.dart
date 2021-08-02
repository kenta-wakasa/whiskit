import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/whisky.dart';
import 'package:whiskit/models/whisky_log.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/review_details_page.dart';
import 'package:whiskit/views/utils/common_whisky_image.dart';
import 'package:path/path.dart' as p;

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MainPage.route);
              context.read(userProvider).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Whisky>>(
        future: WhiskyLogRepository.fetchWhiskyLogListByUser(user),
        builder: (context, AsyncSnapshot<List<Whisky>> asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final whiskyList = asyncSnapshot.data;
          if (whiskyList == null) {
            return const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      foregroundImage: NetworkImage(user.avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: Theme.of(context).textTheme.headline6),
                        const SizedBox(height: 24),
                        Text('今まで飲んできたウィスキー　${whiskyList.length}本'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(32),
                key: const ValueKey('WhiskyScroll'),
                height: 240,
                child: Scrollbar(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 16,
                      childAspectRatio: 2 / 5,
                    ),
                    itemCount: whiskyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final whisky = whiskyList[index];
                      return InkWell(
                        onTap: () {
                          final path = p.join(
                            ReviewDetailsPage.route, // review
                            whisky.ref.id, // whiskyID
                            FirebaseAuth.instance.currentUser!.uid, // userId
                          );
                          Navigator.of(context).pushNamed(path);
                        },
                        // onTap: () => controller.select(whisky),
                        child: CommonWhiskyImage(imageUrl: whisky.imageUrl),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
