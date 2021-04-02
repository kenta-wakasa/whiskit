import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Whisky {
  const Whisky({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.amazon,
    required this.rakuten,
    required this.age,
    required this.alcohol,
    required this.country,
    required this.style,
  });
  static Whisky fromDoc(QueryDocumentSnapshot doc) {
    return Whisky(
      id: doc.data()!['id'] as String,
      imageUrl: doc.data()!['imageUrl'] as String,
      name: doc.data()!['name'] as String,
      amazon: doc.data()!['amazon'] as String,
      rakuten: doc.data()!['rakuten'] as String,
      age: doc.data()!['age'] as int?,
      alcohol: doc.data()!['alcohol'] as int,
      country: doc.data()!['country'] as String,
      style: doc.data()!['style'] as String,
    );
  }

  final String id;
  final String imageUrl;
  final String name;
  final String amazon;
  final String rakuten;
  final int? age;
  final int alcohol;
  final String country;
  final String style;

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
  }) {
    return Whisky(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      amazon: amazon ?? this.amazon,
      rakuten: rakuten ?? this.rakuten,
      age: age ?? this.age,
      alcohol: alcohol ?? this.alcohol,
      country: country ?? this.country,
      style: style ?? this.style,
    );
  }
}

class WhiskyRepository {
  WhiskyRepository._();
  static WhiskyRepository instance = WhiskyRepository._();
  final _whiskyCollectionRef = FirebaseFirestore.instance.collection('WhiskyCollection');

  Future<void> addWhisky(Whisky whisky) async {
    await _whiskyCollectionRef.doc(whisky.id).set(<String, dynamic>{'imageUrl': whisky.imageUrl});
  }

  Future<List<Whisky>> fetchWhiskyList() async {
    final querySnapshot = await _whiskyCollectionRef.get();
    return querySnapshot.docs.map(Whisky.fromDoc).toList();
  }
}
