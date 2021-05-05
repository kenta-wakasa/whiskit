import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/models/user.dart';

/// お気に入りされたことを通知する。
@immutable
class UserNotification {
  const UserNotification({
    required this.ref,
    required this.review,
    required this.user,
    required this.createdAt,
  });

  final User user;
  final DocumentReference ref;
  final Review review;
  final Timestamp createdAt;

  static Future<UserNotification> fromDoc(DocumentSnapshot doc) async {
    final json = doc.data()!;

    final reviewRef = json['reviewRef'] as DocumentReference;
    final userRef = json['userRef'] as DocumentReference;

    final reviewDoc = await reviewRef.get();
    final userDoc = await userRef.get();

    return UserNotification(
      ref: doc.reference,
      review: await Review.fromDoc(reviewDoc),
      user: User.fromDoc(userDoc),
      createdAt: json['createdAt'] as Timestamp,
    );
  }
}
