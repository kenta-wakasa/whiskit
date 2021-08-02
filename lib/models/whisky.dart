import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Whisky {
  const Whisky({
    required this.imageUrl,
    required this.name,
    required this.amazon,
    required this.rakuten,
    required this.age,
    required this.alcohol,
    required this.country,
    required this.style,
    required this.water,
    required this.straight,
    required this.soda,
    required this.rock,
    required this.choco,
    required this.fruity,
    required this.honey,
    required this.malty,
    required this.nutty,
    required this.smoky,
    required this.vanilla,
    required this.woody,
    required this.reviewCount,
    required this.richAverage,
    required this.sweetAverage,
    required this.ref,
  });
  static Whisky fromDoc(DocumentSnapshot doc) {
    return Whisky(
      imageUrl: doc.data()!['imageUrl'] as String,
      name: doc.data()!['name'] as String,
      amazon: doc.data()!['amazon'] as String,
      rakuten: doc.data()!['rakuten'] as String,
      age: doc.data()!['age'] as int,
      alcohol: doc.data()!['alcohol'] as int,
      country: doc.data()!['country'] as String,
      style: doc.data()!['style'] as String,
      straight: doc.data()!['straight'] as int? ?? 0,
      rock: doc.data()!['rock'] as int? ?? 0,
      water: doc.data()!['water'] as int? ?? 0,
      soda: doc.data()!['soda'] as int? ?? 0,
      fruity: doc.data()!['fruity'] as int? ?? 0,
      malty: doc.data()!['malty'] as int? ?? 0,
      smoky: doc.data()!['smoky'] as int? ?? 0,
      woody: doc.data()!['woody'] as int? ?? 0,
      choco: doc.data()!['choco'] as int? ?? 0,
      vanilla: doc.data()!['vanilla'] as int? ?? 0,
      nutty: doc.data()!['nutty'] as int? ?? 0,
      honey: doc.data()!['honey'] as int? ?? 0,
      sweetAverage: doc.data()!['sweetAverage'] as double? ?? 0,
      richAverage: doc.data()!['richAverage'] as double? ?? 0,
      reviewCount: doc.data()!['reviewCount'] as int? ?? 0,
      ref: doc.reference,
    );
  }

  final String imageUrl;
  final String name;
  final String amazon;
  final String rakuten;
  final int age;
  final int alcohol;
  final String country;
  final String style;
  // 飲み方
  final int straight;
  final int rock;
  final int water;
  final int soda;
  // 香り
  final int fruity;
  final int malty;
  final int smoky;
  final int woody;
  final int choco;
  final int vanilla;
  final int nutty;
  final int honey;

  /// 感想が投稿された数
  final int reviewCount;

  /// あまさの平均
  final double richAverage;

  /// 濃厚さの平均
  final double sweetAverage;

  final DocumentReference ref;

  Whisky copyWith({
    String? id,
    String? imageUrl,
    String? name,
    String? amazon,
    String? rakuten,
    int? age,
    int? alcohol,
    String? country,
    String? style,
    DocumentReference? ref,
  }) {
    return Whisky(
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      amazon: amazon ?? this.amazon,
      rakuten: rakuten ?? this.rakuten,
      age: age ?? this.age,
      alcohol: alcohol ?? this.alcohol,
      country: country ?? this.country,
      style: style ?? this.style,
      ref: ref ?? this.ref,
      fruity: fruity,
      malty: malty,
      smoky: smoky,
      woody: woody,
      choco: choco,
      vanilla: vanilla,
      nutty: nutty,
      honey: honey,
      rock: rock,
      soda: soda,
      straight: straight,
      water: water,
      reviewCount: reviewCount,
      richAverage: richAverage,
      sweetAverage: sweetAverage,
    );
  }
}

class WhiskyRepository {
  WhiskyRepository._();
  static WhiskyRepository instance = WhiskyRepository._();
  final collectionRef = FirebaseFirestore.instance.collection('WhiskyCollection');

  // TODO(kenta-wakasa):いずれページネーションに対応する必要がある。
  Future<List<Whisky>> fetchWhiskyList() async {
    /// whisky データはキャッシュ優先で読み込む
    try {
      final querySnapshot = await collectionRef.get(const GetOptions(source: Source.cache));
      return querySnapshot.docs.map(Whisky.fromDoc).toList();
    } on Exception catch (_) {
      final querySnapshot = await collectionRef.get(const GetOptions(source: Source.server));
      return querySnapshot.docs.map(Whisky.fromDoc).toList();
    }
  }

  Future<Whisky> fetchWhiskyById(String whiskyId) async {
    final doc = await collectionRef.doc(whiskyId).get();
    return Whisky.fromDoc(doc);
  }
}
