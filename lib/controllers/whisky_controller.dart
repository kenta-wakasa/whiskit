import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/whisky.dart';

final whiskyProvider = ChangeNotifierProvider(
  (ref) => WhiskyController._().._init(),
);

class WhiskyController extends ChangeNotifier {
  WhiskyController._();

  List<Whisky>? whiskyList;
  Whisky? selectedWhisky;

  Future<void> _init() async {
    await _fetchWhiskyList();
    whiskyList!.shuffle();
    selectedWhisky = whiskyList![Random().nextInt(whiskyList!.length)];
    notifyListeners();
  }

  Future<void> _fetchWhiskyList() async {
    whiskyList = await WhiskyRepository.instance.fetchWhiskyList();
    notifyListeners();
  }

  void select(Whisky whisky) {
    selectedWhisky = whisky;
    notifyListeners();
  }
}
