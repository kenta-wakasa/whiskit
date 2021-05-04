import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/utils/common_widget.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer(builder: (_, watch, __) {
                  watch(userProvider);
                  if (FirebaseAuth.instance.currentUser == null) {
                    return SignInWidget();
                  }
                  return const SizedBox();
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
                          ...reviewList.map((review) {
                            return SizedBox(
                              height: 200,
                              width: 400,
                              child: ReviewWidget(initReview: review, displayImage: true),
                            );
                          }).toList()
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
