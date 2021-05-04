import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/whisky.dart';
import 'package:whiskit/models/whisky_log.dart';

import '/models/review.dart';
import '/models/user.dart';

final postReviewProvider = ChangeNotifierProvider.autoDispose.family(
  (ref, String whiskyId) => PostReviewController._(whiskyId, ref.read(userProvider).user),
);

class PostReviewController extends ChangeNotifier {
  PostReviewController._(this.whiskyId, this.user) {
    init();
  }

  final String whiskyId;
  final User? user;
  Whisky? whisky;
  String title = '';
  String content = '';
  List<HowToDrink> howToDrinkList = <HowToDrink>[];
  List<Aroma> aromaList = <Aroma>[];
  int sweet = 3;
  int rich = 3;

  /// 投稿のための条件を満たしたとき true になる
  bool get validate =>
      title.isNotEmpty == true &&
      content.isNotEmpty == true &&
      howToDrinkList.isNotEmpty == true &&
      aromaList.isNotEmpty == true;

  Future<void> init() async {
    if (user == null) {
      return;
    }

    whisky = await WhiskyRepository.instance.fetchWhiskyById(whiskyId);

    final review = await ReviewRepository.instance.fetchReviewByWhiskyAndUser(
      whiskyId: whiskyId,
      userId: user!.ref.id,
    );
    if (review == null) {
      return;
    }
    title = review.title;
    content = review.content;
    howToDrinkList = review.howToDrinkList;
    aromaList = review.aromaList;
    sweet = review.sweet;
    rich = review.rich;
    notifyListeners();
  }

  Future<void> postReview({required User user}) async {
    if (!validate) {
      return;
    }

    final ref = ReviewRepository.instance.docRef(whiskyId: whiskyId, userId: user.ref.id);

    final review = Review.create(
      user: user,
      ref: ref,
      title: title,
      content: content,
      howToDrinkList: howToDrinkList,
      aromaList: aromaList,
      sweet: sweet,
      rich: rich,
      imageUrl: whisky!.imageUrl,
    );

    final drinkKeys = howToDrinkList.map((e) => e.toString().split('.').last).toList();
    final aromaKeys = aromaList.map((e) => e.toString().split('.').last).toList();

    final whiskyUpdateMap = <String, dynamic>{};

    for (final drinkKey in drinkKeys) {
      whiskyUpdateMap[drinkKey] = FieldValue.increment(1);
    }

    for (final aromaKey in aromaKeys) {
      whiskyUpdateMap[aromaKey] = FieldValue.increment(1);
    }

    whiskyUpdateMap['reviewCount'] = FieldValue.increment(1);

    print(whiskyUpdateMap);

    final doc = await ref.get();

    final whiskyDocRef = review.ref.parent.parent!;

    // 二回目以降の投稿の場合
    if (doc.exists) {
      final batch = FirebaseFirestore.instance.batch()
        ..set(
          review.ref,
          <String, dynamic>{
            'userRef': review.user.ref,
            'title': review.title,
            'content': review.content,
            'howToDrink': review.howToDrinkList.map((e) => e.toString().split('.').last).toList(),
            'aroma': review.aromaList.map((e) => e.toString().split('.').last).toList(),
            'sweet': review.sweet,
            'rich': review.rich,
            'createdAt': review.createdAt,
            'imageUrl': whisky!.imageUrl,
          },
          SetOptions(merge: true),
        ) // 参考:https://tomokazu-kozuma.com/difference-between-set-and-update-when-updating-cloud-firestore-data/
        ..set(
          WhiskyLogRepository.generateDocRef(user: user, whiskyId: whiskyId),
          <String, dynamic>{'createdAt': Timestamp.now()},
        );
      await batch.commit();
      // 初投稿の場合
    } else {
      final batch = FirebaseFirestore.instance.batch()
        ..set(
          review.ref,
          <String, dynamic>{
            'userRef': review.user.ref,
            'title': review.title,
            'content': review.content,
            'howToDrink': review.howToDrinkList.map((e) => e.toString().split('.').last).toList(),
            'aroma': review.aromaList.map((e) => e.toString().split('.').last).toList(),
            'sweet': review.sweet,
            'rich': review.rich,
            'createdAt': review.createdAt,
            'favoriteCount': 0, //初めての投稿の場合は 0 で初期化する
            'imageUrl': whisky!.imageUrl,
          },
          SetOptions(merge: true),
        ) // 参考:https://tomokazu-kozuma.com/difference-between-set-and-update-when-updating-cloud-firestore-data/
        ..set(
          WhiskyLogRepository.generateDocRef(user: user, whiskyId: whiskyId),
          <String, dynamic>{'createdAt': Timestamp.now()},
        )
        // ユーザーの投稿レビューの総数をカウントアップする
        ..update(
          UserRepository.instance.collectionRef.doc(user.ref.id),
          <String, dynamic>{
            'reviewCount': FieldValue.increment(1),
          },
        )
        // ウィスキーの投稿レビューの総数をカウントアップする
        ..set(
          whiskyDocRef,
          whiskyUpdateMap,
          SetOptions(merge: true),
        );

      await batch.commit();
    }

    // 平均値を更新する
    final whiskySnapshot = await whiskyDocRef.get();
    final whiskyReviewCount = whiskySnapshot.data()!['reviewCount'] as int;

    final oldSweetAverage = whiskySnapshot.data()!['sweetAverage'] as int? ?? 0;
    final newSweetAverage = (((whiskyReviewCount - 1) * oldSweetAverage) + sweet) / whiskyReviewCount;

    final oldRichAverage = whiskySnapshot.data()!['richAverage'] as int? ?? 0;
    final newRichAverage = (((whiskyReviewCount - 1) * oldRichAverage) + rich) / whiskyReviewCount;

    await whiskyDocRef.update(
      <String, dynamic>{
        'sweetAverage': newSweetAverage,
        'richAverage': newRichAverage,
      },
    );
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
