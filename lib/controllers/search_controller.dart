import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/whisky.dart';

final searchProvider = ChangeNotifierProvider.autoDispose((ref) => SearchController());

class SearchController extends ChangeNotifier {
  List<Whisky> resultWhiskyList = <Whisky>[];

  void search({required List<Whisky>? whiskyList, required String searchToText}) {
    if (whiskyList == null || searchToText.isEmpty) {
      resultWhiskyList.clear();
      notifyListeners();
      return;
    }
    final whiskyNameList = whiskyList.map((e) => e.name).toList();
    for (final whiskyName in whiskyNameList) {
      if (whiskyName.contains(searchToText)) {
        resultWhiskyList.add(whiskyList[whiskyNameList.indexOf(whiskyName)]);
      }
    }
    notifyListeners();
  }
}
