import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class User {
  const User({required this.id, required this.name});
  final String id;
  final String name;

  User copyWith({String? id, String? name}) {
    return User(id: id ?? this.id, name: name ?? this.id);
  }
}

class UserRepository {
  UserRepository._();
  static UserRepository instance = UserRepository._();
  final _usersCollectionRef = FirebaseFirestore.instance.collection('user');

  Future<void> addUsers(User user) async {
    await _usersCollectionRef.doc(user.id).set(<String, dynamic>{'name': user.name});
  }
}
