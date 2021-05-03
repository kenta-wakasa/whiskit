import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit/models/user.dart';

@immutable
class FavoriteReview {
  const FavoriteReview({
    required this.ref,
    required this.user,
    required this.createdAt,
  });
  final DocumentReference ref;
  final User user;
  final Timestamp createdAt;
}
