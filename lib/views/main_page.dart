import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/search_controller.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/controllers/whisky_list_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/views/home_page.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/selected_whisky.dart';
import 'package:whiskit/views/sing_in_widget.dart';
import 'package:whiskit/views/whisky_details_page.dart';
import 'package:whiskit/views/whisky_list_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          alignment: Alignment.topLeft,
          children: [
            Row(
              children: [
                Text('WHISKIT', style: textTheme.headline5),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 40),
                Consumer(
                  builder: (_, watch, __) {
                    final controller = watch(searchProvider);
                    return SizedBox(
                      width: 240,
                      height: 40,
                      child: TextFormField(
                        key: const ValueKey('Search'),
                        onChanged: (text) {
                          controller.search(
                            whiskyList: context.read(whiskyProvider).whiskyList!,
                            searchToText: text,
                          );
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            gapPadding: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24,
                          ),
                          hintText: '名前で調べる...',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              // サインインしていない
              if (context.read(userProvider).user == null) {
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
                child: Consumer(
                  builder: (_, watch, __) {
                    final user = watch(userProvider).user;
                    if (user == null) {
                      return const Icon(Icons.account_circle_rounded);
                    }
                    return CircleAvatar(foregroundImage: NetworkImage(user.avatarUrl));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// サインインのウィジェット
                Consumer(builder: (_, watch, __) {
                  watch(userProvider);
                  if (FirebaseAuth.instance.currentUser == null) {
                    return SignInWidget();
                  }
                  return const SizedBox();
                }),

                Consumer(builder: (_, watch, __) {
                  final selectedWhisky = watch(whiskyProvider).selectedWhisky;
                  if (selectedWhisky == null) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: SelectedWhisky(selectedWhisky: selectedWhisky),
                  );
                }),

                const WhiskyListWidget(key: ValueKey('WhiskyList')),
                FutureBuilder(
                  future: ReviewRepository.instance.fetchLatestReviewList(),
                  builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    final reviewList = snapshot.data!;
                    return SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 48),
                          Text(
                            '新着レビュー',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const Divider(),
                          const SizedBox(height: 16),
                          ...reviewList.map(
                            (review) {
                              return Container(
                                height: 200,
                                width: 400,
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ReviewWidget(
                                  initReview: review,
                                  displayImage: true,
                                ),
                              );
                            },
                          ).toList()
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (_, watch, __) {
              final controller = watch(searchProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...controller.resultWhiskyList.map(
                    (whisky) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '${WhiskyDetailsPage.route}/${whisky.ref.id}',
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(4),
                          color: Colors.white.withOpacity(.9),
                          width: 240,
                          height: 32,
                          child: Text(
                            whisky.name,
                            style: const TextStyle(color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ).toList()
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
