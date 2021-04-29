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
    required this.updatedAt,
    required this.howToDrink,
    required this.aroma,
    required this.sweet,
    required this.rich,
  });

  Review.create({
    required this.user,
    required this.ref,
    required this.title,
    required this.content,
    required this.howToDrink,
    required this.aroma,
    required this.sweet,
    required this.rich,
  })  : createdAt = Timestamp.now(),
        updatedAt = Timestamp.now();

  final User user;
  final DocumentReference ref;
  final String title;
  final String content;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final List<HowToDrink> howToDrink;
  final List<Aroma> aroma;
  final int sweet;
  final int rich;

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
      updatedAt: doc.data()!['updatedAt'] as Timestamp,
      howToDrink: howToDrinkEnumList,
      aroma: aromaEnumList,
      sweet: doc.data()!['sweet'] as int,
      rich: doc.data()!['rich'] as int,
    );
  }

  Review copyWith({
    User? user,
    DocumentReference? ref,
    String? title,
    String? content,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    List<HowToDrink>? howToDrink,
    List<Aroma>? aroma,
    int? sweet,
    int? rich,
  }) {
    return Review._(
      user: user ?? this.user,
      ref: ref ?? this.ref,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      howToDrink: howToDrink ?? this.howToDrink,
      sweet: sweet ?? this.sweet,
      rich: rich ?? this.rich,
      aroma: aroma ?? this.aroma,
    );
  }
}

class ReviewRepository {
  ReviewRepository._();
  static ReviewRepository instance = ReviewRepository._();

  CollectionReference collectionRef({required String whiskyId}) {
    return WhiskyRepository.instance.collectionRef.doc(whiskyId).collection('WhiskyReview');
  }

  // TODO: ページング機能が必要
  Future<List<Review>> fetchReviewList({required String whiskyId}) async {
    final querySnapshot = await collectionRef(whiskyId: whiskyId).get();
    return Future.wait(querySnapshot.docs.map(Review.fromDoc).toList());
  }

  /// 最新一件を取得する
  Future<Review> fetchFirstReview({required String whiskyId}) async {
    final querySnapshot = await collectionRef(whiskyId: whiskyId).orderBy('createdAt', descending: true).limit(1).get();
    return Review.fromDoc(querySnapshot.docs.first);
  }
}

enum HowToDrink { straight, rock, water, soda }

enum Aroma { fruity, malty, smoky, woody, choco, vanilla, nutty, honey }
