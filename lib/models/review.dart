import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:whiskit/models/whisky.dart';

import 'user.dart';

@immutable
class Review {
  const Review._({
    required this.user,
    required this.ref,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.howToDrinkList,
    required this.aromaList,
    required this.sweet,
    required this.rich,
    this.favoriteCount,
  });

  Review.create({
    required this.user,
    required this.ref,
    required this.title,
    required this.content,
    required this.howToDrinkList,
    required this.aromaList,
    required this.sweet,
    required this.rich,
    this.favoriteCount,
  }) : createdAt = Timestamp.now();

  final User user;
  final DocumentReference ref;
  final String title;
  final String content;
  final Timestamp createdAt;
  final List<HowToDrink> howToDrinkList;
  final List<Aroma> aromaList;
  final int sweet;
  final int rich;
  final int? favoriteCount;

  static Future<Review> fromDoc(DocumentSnapshot doc) async {
    var howToDrinkStringList = <String>[];
    var aromaStringList = <String>[];

    // 列挙体の list に変換
    howToDrinkStringList = List.from(doc.data()!['howToDrink'] as List);
    final howToDrinkEnumList = howToDrinkStringList.map(
      (howToDrinkString) {
        final howToDrinkEnum = EnumToString.fromString(HowToDrink.values, howToDrinkString);
        return howToDrinkEnum!;
      },
    ).toList();

    // 列挙体の list に変換
    aromaStringList = List.from(doc.data()!['aroma'] as List);
    final aromaEnumList = aromaStringList.map(
      (aromaString) {
        final aromaEnum = EnumToString.fromString(Aroma.values, aromaString);
        return aromaEnum!;
      },
    ).toList();

    final userRef = doc.data()!['userRef'] as DocumentReference;
    final snapshot = await userRef.get();
    final user = User.fromDoc(snapshot);

    return Review._(
      user: user,
      ref: doc.reference,
      title: doc.data()!['title'] as String,
      content: doc.data()!['content'] as String,
      createdAt: doc.data()!['createdAt'] as Timestamp,
      howToDrinkList: howToDrinkEnumList,
      aromaList: aromaEnumList,
      sweet: doc.data()!['sweet'] as int,
      rich: doc.data()!['rich'] as int,
      favoriteCount: doc.data()!['favoriteCount'] == null ? 0 : doc.data()!['favoriteCount'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Review && runtimeType == other.runtimeType && ref == other.ref;

  @override
  int get hashCode => ref.hashCode;

  Review copyWith({
    User? user,
    DocumentReference? ref,
    String? title,
    String? content,
    Timestamp? createdAt,
    List<HowToDrink>? howToDrinkList,
    List<Aroma>? aromaList,
    int? sweet,
    int? rich,
    int? favoriteCount,
  }) {
    return Review._(
      user: user ?? this.user,
      ref: ref ?? this.ref,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      howToDrinkList: howToDrinkList ?? this.howToDrinkList,
      sweet: sweet ?? this.sweet,
      rich: rich ?? this.rich,
      aromaList: aromaList ?? this.aromaList,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }
}

class ReviewRepository {
  ReviewRepository._();
  static ReviewRepository instance = ReviewRepository._();

  /// [whiskyId] と [userId] ref を取得する
  DocumentReference docRef({required String whiskyId, required String userId}) {
    return collectionRef(whiskyId: whiskyId).doc(userId);
  }

  CollectionReference collectionRef({required String whiskyId}) {
    return WhiskyRepository.instance.collectionRef.doc(whiskyId).collection('WhiskyReview');
  }

  // TODO: ページング機能が必要

  /// レビューの一覧を取得する
  Future<List<Review>> fetchReviewList({required String whiskyId}) async {
    final querySnapshot = await collectionRef(whiskyId: whiskyId).get();
    return Future.wait(querySnapshot.docs.map(Review.fromDoc).toList());
  }

  /// 最新一件を取得する
  Future<Review> fetchFirstReview({required String whiskyId}) async {
    final querySnapshot = await collectionRef(whiskyId: whiskyId).orderBy('createdAt', descending: true).limit(1).get();
    return Review.fromDoc(querySnapshot.docs.first);
  }

  /// [whiskyId] と [userId] からレビューを取得する
  Future<Review?> fetchReviewByWhiskyAndUser({required String whiskyId, required String userId}) async {
    final doc = await docRef(whiskyId: whiskyId, userId: userId).get();
    if (doc.exists) {
      return Review.fromDoc(doc);
    }
  }

  Review addFavorite(Review review) {
    final favoriteCountUp = review.favoriteCount! + 1;
    review.ref.update(<String, dynamic>{'favoriteCount': favoriteCountUp});
    return review.copyWith(favoriteCount: favoriteCountUp);
  }

  Review removeFavorite(Review review) {
    final favoriteCountUp = review.favoriteCount! - 1;
    review.ref.update(<String, dynamic>{'favoriteCount': favoriteCountUp});
    return review.copyWith(favoriteCount: favoriteCountUp);
  }
}

enum HowToDrink { straight, rock, water, soda }

enum Aroma { fruity, malty, smoky, woody, choco, vanilla, nutty, honey }
