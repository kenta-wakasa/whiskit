import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/views/main_page.dart';

class ReviewDetailsPage extends StatelessWidget {
  const ReviewDetailsPage({required this.reviewRef});
  static const route = '/review';
  final DocumentReference reviewRef;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: reviewRef.get().then(Review.fromDoc),
        builder: (
          context,
          AsyncSnapshot<Review> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          final review = snapshot.data;
          if (review == null) {
            // リダイレクトのやり方:参考 https://stackoverflow.com/questions/55618717/error-thrown-on-navigator-pop-until-debuglocked-is-not-true
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pushReplacementNamed(MainPage.route);
            });
            return const SizedBox();
          }
          return Center(
            child: Text(review.content),
          );
        },
      ),
    );
  }
}
