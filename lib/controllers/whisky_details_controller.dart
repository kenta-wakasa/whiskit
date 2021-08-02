import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/models/review.dart';
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
  List<_AromaCount> aromaCountList = <_AromaCount>[];
  List<Review> reviewList = <Review>[];

  /// 初期化メソッド
  Future<void> _init() async {
    whisky = await WhiskyRepository.instance.fetchWhiskyById(whiskyId);
    _sortAromaList();
    await fetchReview();
  }

  /// グラフを表示するか
  bool get displayGraph => !(whisky?.richAverage == 0 || whisky?.sweetAverage == 0);

  /// アロマリストを多い順でソートする
  void _sortAromaList() {
    final tmpAromaCountList = <_AromaCount>[
      _AromaCount(name: 'モルト', count: whisky!.malty),
      _AromaCount(name: 'スモーキー', count: whisky!.smoky),
      _AromaCount(name: 'ウッディ', count: whisky!.woody),
      _AromaCount(name: 'チョコ', count: whisky!.choco),
      _AromaCount(name: 'バニラ', count: whisky!.vanilla),
      _AromaCount(name: 'フルーティ', count: whisky!.fruity),
      _AromaCount(name: 'ナッツ', count: whisky!.nutty),
      _AromaCount(name: 'ハニー', count: whisky!.honey),
    ].where((element) => element.count > 0).toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    if (tmpAromaCountList.length > 3) {
      tmpAromaCountList.sublist(0, 2);
    }
    aromaCountList = tmpAromaCountList;
    notifyListeners();
  }

  Future<void> fetchReview() async {
    reviewList = await ReviewRepository.instance.fetchReviewByWhiskyId(whiskyId: whiskyId);
    notifyListeners();
  }
}

class _AromaCount {
  const _AromaCount({required this.name, required this.count});
  final String name;
  final int count;
}
