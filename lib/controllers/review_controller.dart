import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/models/user.dart';

final reviewProvider = ChangeNotifierProvider.autoDispose.family(
  (ref, Review review) {
    final user = ref.read(userProvider).user;
    return ReviewController._(review, user);
  },
);

class ReviewController extends ChangeNotifier {
  ReviewController._(this.review, this.user) {
    init();
  }

  Review review;
  bool exitsFavorite = false;
  final User? user;

  Future<void> init() async {
    if (user == null) {
      exitsFavorite = false;
      return;
    }
    final doc = await review.ref.collection('FavoriteReview').doc(user!.ref.id).get();
    exitsFavorite = doc.exists;
    notifyListeners();
  }

  void changeFavorite() {
    if (user == null) {
      print('required log in');
      return;
    }

    final uid = user!.ref.id;
    final favoriteReviewRef = review.ref.collection('FavoriteReview').doc(uid);

    // お気に入りを削除する
    if (exitsFavorite) {
      review = ReviewRepository.instance.removeFavorite(review);
      favoriteReviewRef.delete();
      UserRepository.instance.collectionRef.doc(review.user.ref.id).update(
        <String, dynamic>{
          'favoriteCount': FieldValue.increment(-1),
        },
      );
      exitsFavorite = false;
    }
    // お気に入りを追加する
    else {
      review = ReviewRepository.instance.addFavorite(review);
      favoriteReviewRef.set(<String, dynamic>{
        'userRef': FirebaseFirestore.instance.collection('UsersCollection').doc(uid),
        'createdAt': Timestamp.now(),
      });
      UserRepository.instance.collectionRef.doc(review.user.ref.id).update(
        <String, dynamic>{
          'favoriteCount': FieldValue.increment(1),
        },
      );
      exitsFavorite = true;
    }

    notifyListeners();
  }
}
