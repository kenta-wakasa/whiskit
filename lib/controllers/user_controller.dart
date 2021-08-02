import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whiskit/models/user.dart';
import 'package:whiskit/models/user_notification.dart';

final userProvider = ChangeNotifierProvider<UserController>(
  (ref) => UserController._().._init(),
);

class UserController extends ChangeNotifier {
  UserController._();

  /// [user]の切り替わりを監視し続ける
  void _init() {
    _sub = _auth.authStateChanges().listen(signIn);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  late StreamSubscription _sub;
  User? _user;

  User? get user => _user;

  Future<void> signIn(auth.User? authUser) async {
    if (authUser == null) {
      _user = null;
    } else {
      _user = User.fromAuthUser(authUser);
      await UserRepository.instance.addUsers(User.fromAuthUser(authUser));
      _user = await UserRepository.instance.fetchByRef(_user!.ref);
      print(_user?.notificationCount);
    }
    notifyListeners();
  }

  void signOut() {
    _user = null;
    _auth.signOut();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    await UserRepository.instance.addUsers(User.fromAuthUser(_auth.currentUser!));
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    if (_user == null) {
      return;
    }
    _user = await _user!.updateName(name);
    notifyListeners();
  }

  Future<void> updateUserNotification() async {
    _user = await _user!.updateUserNotification();
    notifyListeners();
  }

  /// 新着の通知を取得する
  Future<List<UserNotification>> fetchLatestNotification() async {
    final user = this.user;
    if (user == null) {
      return <UserNotification>[];
    }
    final snapshot = await user.ref
        .collection('UserNotification')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .limit(10)
        .get();
    return Future.wait(snapshot.docs.map(UserNotification.fromDoc).toList());
  }
}
