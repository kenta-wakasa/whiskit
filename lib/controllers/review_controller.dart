import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/whisky_log.dart';

import '/models/review.dart';
import '/models/user.dart';

final reviewProvider = ChangeNotifierProvider.family(
  (ref, String whiskyId) => ReviewController._(whiskyId),
);

class ReviewController extends ChangeNotifier {
  ReviewController._(this.whiskyId);

  final String whiskyId;
  String title = '';
  String content = '';
  List<HowToDrink> howToDrinkList = <HowToDrink>[];
  List<Aroma> aromaList = <Aroma>[];
  int sweet = 3;
  int rich = 3;

  bool get validate => title.isEmpty || content.isEmpty || howToDrinkList.isEmpty || aromaList.isEmpty;

  void reset() {
    title = '';
    content = '';
    howToDrinkList = <HowToDrink>[];
    aromaList = <Aroma>[];
    sweet = 3;
    rich = 3;
  }

  Future<Review> fetchFirstReview() async {
    return ReviewRepository.instance.fetchFirstReview(whiskyId: whiskyId);
  }

  Future<void> postReview({required User? user}) async {
    if (user == null || validate) {
      return;
    }

    final ref = ReviewRepository.instance.collectionRef(whiskyId: whiskyId).doc(user.ref.id);

    final review = Review.create(
      user: user,
      ref: ref,
      title: title,
      content: content,
      howToDrink: howToDrinkList,
      aroma: aromaList,
      sweet: sweet,
      rich: rich,
    );

    final batch = FirebaseFirestore.instance.batch()
      ..set(review.ref, <String, dynamic>{
        'userRef': review.user.ref,
        'title': review.title,
        'content': review.content,
        'howToDrink': review.howToDrink.map((e) => e.toString().split('.').last).toList(),
        'aroma': review.aroma.map((e) => e.toString().split('.').last).toList(),
        'sweet': review.sweet,
        'rich': review.rich,
        'createdAt': review.createdAt,
        'updatedAt': review.updatedAt,
      })
      ..set(WhiskyLogRepository.generateDocRef(user: user, whiskyId: whiskyId),
          <String, dynamic>{'createdAt': Timestamp.now()});

    await batch.commit();
    reset();
  }

  void updateTitle(String value) {
    title = value;
    notifyListeners();
  }

  void updateContent(String value) {
    content = value;
    notifyListeners();
  }

  void updateSweet(int sweet) {
    this.sweet = sweet;
    notifyListeners();
  }

  void updateRich(int rich) {
    this.rich = rich;
    notifyListeners();
  }

  void addHowToDrink(HowToDrink howToDrink) {
    howToDrinkList.add(howToDrink);
    notifyListeners();
  }

  void removeHowToDrink(HowToDrink howToDrink) {
    howToDrinkList.remove(howToDrink);
    notifyListeners();
  }

  void addAroma(Aroma aroma) {
    aromaList.add(aroma);
    notifyListeners();
  }

  void removeAroma(Aroma aroma) {
    aromaList.remove(aroma);
    notifyListeners();
  }
}
