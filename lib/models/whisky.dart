import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Whisky {
  const Whisky({required this.id, required this.imageUrl});
  static Whisky fromDoc(QueryDocumentSnapshot doc) {
    return Whisky(
      id: doc.get('id') as String,
      imageUrl: doc.get('imageUrl') as String,
    );
  }

  final String id;
  final String imageUrl;

  Whisky copyWith({String? id, String? imageUrl}) {
    return Whisky(id: id ?? this.id, imageUrl: imageUrl ?? this.imageUrl);
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
