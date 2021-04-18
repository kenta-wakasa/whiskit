import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/review.dart';
import '/models/user.dart';
import '/models/whisky.dart';

final reviewProvider = ChangeNotifierProvider(
  (ref) => ReviewController._(),
);

class ReviewController extends ChangeNotifier {
  ReviewController._();

  String _title = '';
  String _content = '';
  List<HowToDrink> howToDrinkList = <HowToDrink>[];
  List<Aroma> aromaList = <Aroma>[];
  int sweet = 3;
  int rich = 3;

  bool get validate => _title.isEmpty || _content.isEmpty || howToDrinkList.isEmpty || aromaList.isEmpty;

  void updateTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void updateContent(String value) {
    _content = value;
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

  Future<void> postReview({required User? user, required String whiskyId}) async {
    if (user == null || validate) {
      return;
    }

    final ref = WhiskyRepository.instance.collectionRef.doc(whiskyId).collection('WhiskyReview').doc(user.ref.id);

    final review = Review.create(
      userRef: user.ref,
      ref: ref,
      title: _title,
      content: _content,
      howToDrink: howToDrinkList,
      aroma: aromaList,
      sweet: sweet,
      rich: rich,
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
