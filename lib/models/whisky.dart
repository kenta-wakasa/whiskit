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
    required this.ref,
  });
  static Whisky fromDoc(DocumentSnapshot doc) {
    return Whisky(
      imageUrl: doc.data()!['imageUrl'] as String,
      name: doc.data()!['name'] as String,
      amazon: doc.data()!['amazon'] as String,
      rakuten: doc.data()!['rakuten'] as String,
      age: doc.data()!['age'] as int?,
      alcohol: doc.data()!['alcohol'] as int,
      country: doc.data()!['country'] as String,
      style: doc.data()!['style'] as String,
      ref: doc.reference,
    );
  }

  final String imageUrl;
  final String name;
  final String amazon;
  final String rakuten;
  final int? age;
  final int alcohol;
  final String country;
  final String style;
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
