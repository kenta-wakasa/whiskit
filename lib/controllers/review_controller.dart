import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/whisky.dart';

import '/models/review.dart';
import '/models/user.dart';

final reviewProvider = ChangeNotifierProvider(
  (ref) => ReviewController._(),
);

class ReviewController extends ChangeNotifier {
  ReviewController._();

  String? title;
  String? content;
  List<HowToDrink>? howToDrink;
  List<Aroma>? aroma;
  int? sweet;
  int? rich;

  Future<void> postReview({required User? user, required String whiskyId}) async {
    if (user == null ||
        title == null ||
        content == null ||
        howToDrink == null ||
        aroma == null ||
        sweet == null ||
        rich == null) {
      return;
    }

    final ref = WhiskyRepository.instance.collectionRef.doc(whiskyId).collection('WhiskyReview').doc(user.ref.id);

    final review = Review.create(
      userRef: user.ref,
      ref: ref,
      title: title!,
      content: content!,
      howToDrink: howToDrink!,
      aroma: aroma!,
      sweet: sweet!,
      rich: rich!,
    );

    await review.ref.set(<String, dynamic>{
      'userRef': review.userRef,
      'title': review.title,
      'content': review.content,
      'howToDrink': review.howToDrink.map((e) => e.toString().split('.').last).toList(),
      'aroma': review.aroma.map((e) => e.toString().split('.').last).toList(),
      'sweet': review.sweet,
      'rich': review.rich,
      'createdAt': review.createdAt,
      'updatedAt': review.updatedAt,
    });
  }
}
