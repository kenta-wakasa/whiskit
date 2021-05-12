import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/search_controller.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/controllers/whisky_list_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/views/pop_up_notification_menu.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/search_form.dart';
import 'package:whiskit/views/selected_whisky.dart';
import 'package:whiskit/views/sing_in_widget.dart';
import 'package:whiskit/views/utils/common_user_icon.dart';
import 'package:whiskit/views/utils/common_widget.dart';
import 'package:whiskit/views/whisky_details_page.dart';
import 'package:whiskit/views/whisky_list_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const route = '/';

  @override
  Widget build(BuildContext context) {
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
                logo(context),
                const Spacer(flex: 1),
                Expanded(flex: 4, child: SearchForm()),
                const Spacer(flex: 1),
              ],
            ),
          ],
        ),
        actions: [
          PopUpNotificationMenu(),
          CommonUserIcon(),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                      child: SelectedWhisky(whisky: selectedWhisky),
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
