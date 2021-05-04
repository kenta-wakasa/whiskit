import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/whisky.dart';

final whiskyProvider = ChangeNotifierProvider(
  (ref) => WhiskyListController._().._init(),
);

class WhiskyListController extends ChangeNotifier {
  WhiskyListController._();

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
