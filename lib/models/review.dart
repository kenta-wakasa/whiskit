import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

@immutable
class Review {
  const Review._({
    required this.userRef,
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
    required this.userRef,
    required this.ref,
    required this.title,
    required this.content,
    required this.howToDrink,
    required this.aroma,
    required this.sweet,
    required this.rich,
  })  : createdAt = Timestamp.now(),
        updatedAt = Timestamp.now();

  final DocumentReference userRef;
  final DocumentReference ref;
  final String title;
  final String content;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final List<HowToDrink> howToDrink;
  final List<Aroma> aroma;
  final int sweet;
  final int rich;

  static Review fromDoc(DocumentSnapshot doc) {
    // 列挙体の list に変換
    final howToDrinkStringList = doc.data()!['howToDrink'] as List<String>;
    final howToDrinkEnumList = howToDrinkStringList.map(
      (howToDrinkString) {
        final howToDrinkEnum = EnumToString.fromString(HowToDrink.values, howToDrinkString);
        return howToDrinkEnum!;
      },
    ).toList();

    // 列挙体の list に変換
    final aromaStringList = doc.data()!['aroma'] as List<String>;
    final aromaEnumList = aromaStringList.map(
      (aromaString) {
        final aromaEnum = EnumToString.fromString(Aroma.values, aromaString);
        return aromaEnum!;
      },
    ).toList();

    return Review._(
      userRef: doc.data()!['userRef'] as DocumentReference,
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
    DocumentReference? userRef,
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
      userRef: userRef ?? this.userRef,
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

class ReviewRepository {}

enum HowToDrink {
  straight,
  rock,
  water,
  soda,
}

enum Aroma {
  fruity,
  malty,
  smoky,
  woody,
  choco,
  vanilla,
  nutty,
}
