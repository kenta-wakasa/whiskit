import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/whisky.dart';

final whiskyDetailsProvider = ChangeNotifierProvider.autoDispose.family(
  (ref, String whiskyId) => WhiskyDetailsController(whiskyId: whiskyId),
);

class WhiskyDetailsController extends ChangeNotifier {
  WhiskyDetailsController({required this.whiskyId}) {
    _init();
  }
  final String whiskyId;
  Whisky? whisky;

  Future<void> _init() async {
    whisky = await WhiskyRepository.instance.fetchWhiskyById(whiskyId);
    notifyListeners();
  }
}
