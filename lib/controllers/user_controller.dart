import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/models/user.dart';

final userProvider = ChangeNotifierProvider<UserController>(
  (ref) => UserController._()..init(),
);

class UserController extends ChangeNotifier {
  UserController._();

  /// [user]の切り替わりを監視し続ける
  void init() => _sub = _auth.authStateChanges().listen(signIn);

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  late StreamSubscription _sub;
  User? _user;

  User? get user => _user;

  Future<void> signIn(auth.User? user) async {
    if (user == null) {
      _user = User.anonymous();
    } else {
      await UserRepository.instance.addUsers(User.fromUser(user));
      _user = await UserRepository.instance.fetchByUserId(user.uid);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signInAnonymously();
    _user = User.anonymous();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    await UserRepository.instance.addUsers(User.fromUser(_auth.currentUser!));
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    if (_user == null) {
      return;
    }
    _user = await user!.updateName(name);
    notifyListeners();
  }
}
