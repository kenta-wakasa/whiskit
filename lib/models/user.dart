import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

@immutable
class User {
  const User._({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.avatarUrl,
  });

  factory User.anonymous() {
    return User._(
      id: null,
      name: 'ゲスト',
      createdAt: Timestamp.fromDate(DateTime.now()),
      avatarUrl: null,
    );
  }

  factory User.fromUser(auth.User user) {
    return User._(
      id: user.uid,
      name: user.displayName!,
      createdAt: Timestamp.now(),
      avatarUrl: user.photoURL!,
    );
  }

  static User fromDoc(DocumentSnapshot doc) => User._(
        id: doc.id,
        name: doc.data()!['name'] as String,
        createdAt: doc.data()!['createdAt'] as Timestamp,
        avatarUrl: doc.data()!['avatarUrl'] as String,
      );

  final String? id;
  final String name;
  final Timestamp createdAt;
  final String? avatarUrl;

  bool get anonymous => id == null;

  Future<User> updateName(String name) async {
    final users = copyWith(name: name);
    await UserRepository.instance.updateUsers(users);
    return users;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is User && other.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode ^ avatarUrl.hashCode;

  User copyWith({
    String? id,
    String? name,
    Timestamp? createdAt,
    String? avatarUrl,
  }) =>
      User._(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}

class UserRepository {
  UserRepository._();
  static UserRepository instance = UserRepository._();
  final _users = FirebaseFirestore.instance.collection('UsersCollection');

  Future<User> fetchByUserId(String userId) async {
    return User.fromDoc(await _users.doc(userId).get());
  }

  /// Users が既に存在している場合は何もしない
  Future<void> addUsers(User users) async {
    final snapshot = await _users.doc(users.id).get();
    if (!snapshot.exists) {
      await _users.doc(users.id).set(
        <String, dynamic>{
          'name': users.name,
          'createdAt': users.createdAt,
          'avatarUrl': users.avatarUrl,
        },
      );
    }
  }

  Future<void> updateUsers(User users) async {
    await _users.doc(users.id).update(
      <String, dynamic>{'name': users.name, 'createdAt': users.createdAt, 'avatarUrl': users.avatarUrl},
    );
  }
}
