import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

@immutable
class User {
  const User._({
    required this.name,
    required this.createdAt,
    required this.avatarUrl,
    required this.ref,
  });

  factory User.fromAuthUser(auth.User authUser) {
    return User._(
      name: authUser.displayName!,
      createdAt: Timestamp.now(),
      avatarUrl: authUser.photoURL!,
      ref: UserRepository.instance.collectionRef.doc(authUser.uid),
    );
  }

  static User fromDoc(DocumentSnapshot doc) {
    return User._(
      name: doc.data()!['name'] as String,
      createdAt: doc.data()!['createdAt'] as Timestamp,
      avatarUrl: doc.data()!['avatarUrl'] as String,
      ref: doc.reference,
    );
  }

  final String name;
  final Timestamp createdAt;
  final String avatarUrl;
  final DocumentReference ref;

  Future<User> updateName(String name) async {
    final users = copyWith(name: name);
    await UserRepository.instance.updateUsers(users);
    return users;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is User && other.ref == ref;

  @override
  int get hashCode => ref.hashCode ^ name.hashCode ^ createdAt.hashCode ^ avatarUrl.hashCode;

  User copyWith({
    String? id,
    String? name,
    Timestamp? createdAt,
    String? avatarUrl,
    DocumentReference? ref,
  }) {
    return User._(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ref: ref ?? this.ref,
    );
  }
}

class UserRepository {
  UserRepository._();
  static UserRepository instance = UserRepository._();
  final collectionRef = FirebaseFirestore.instance.collection('UsersCollection');

  Future<User> fetchByUserId(String userId) async {
    return User.fromDoc(await collectionRef.doc(userId).get());
  }

  Future<User> fetchByRef(DocumentReference ref) async {
    return User.fromDoc(await ref.get());
  }

  /// Users が既に存在している場合は何もしない
  Future<void> addUsers(User user) async {
    final snapshot = await user.ref.get();
    if (!snapshot.exists) {
      await user.ref.set(
        <String, dynamic>{
          'name': user.name,
          'createdAt': user.createdAt,
          'avatarUrl': user.avatarUrl,
        },
      );
    }
  }

  Future<void> updateUsers(User user) async {
    await user.ref.update(
      <String, dynamic>{
        'name': user.name,
        'createdAt': user.createdAt,
        'avatarUrl': user.avatarUrl,
      },
    );
  }
}
