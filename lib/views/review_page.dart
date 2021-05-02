import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedantic/pedantic.dart';

import '/controllers/review_controller.dart';
import '/controllers/user_controller.dart';
import '/models/review.dart';
import '/views/utils/easy_button.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({required this.whiskyId});
  static const route = '/review';
  final String whiskyId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final textTheme = Theme.of(context).textTheme;
    final controller = watch(reviewProvider(whiskyId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text('WHISKIT', style: textTheme.headline5)],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: EasyButton(
              primary: Colors.white,
              onPrimary: Colors.black,
              onPressed: controller.validate
                  ? null
                  : () async {
                      unawaited(
                        showDialog<void>(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                      await controller.postReview(user: context.read(userProvider).user);
                      Navigator.of(context).pop();
                      await showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text('投稿しました！'),
                            actions: [
                              TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
              text: '投稿',
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: double.infinity),
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        const Text('飲み方'),
                        const SizedBox(width: 8),
                        controller.howToDrinkList.isEmpty
                            ? Text(
                                'ひとつ以上選択してください',
                                style: textTheme.caption,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: [for (final howToDrink in HowToDrink.values) howToDrinkButton(howToDrink, controller)],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        const Text('香り'),
                        const SizedBox(width: 8),
                        controller.aromaList.isEmpty
                            ? Text(
                                'ひとつ以上選択してください',
                                style: textTheme.caption,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: [for (final aroma in Aroma.values) aromaButton(aroma, controller)],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(
                          width: 72,
                          child: Text('すっきり'),
                        ),
                        Slider(
                          label: '濃厚さ',
                          value: controller.rich.toDouble(),
                          onChanged: (value) => controller.updateRich(value.toInt()),
                          min: 1,
                          max: 5,
                          divisions: 4,
                        ),
                        const SizedBox(
                          width: 72,
                          child: Text('濃厚'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 72,
                          child: Text('スパイシー'),
                        ),
                        Slider(
                          label: 'あまさ',
                          value: controller.sweet.toDouble(),
                          onChanged: (value) => controller.updateSweet(value.toInt()),
                          min: 1,
                          max: 5,
                          divisions: 4,
                        ),
                        const SizedBox(
                          width: 72,
                          child: Text('あまい'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        maxLines: 1,
                        style: textTheme.headline5,
                        onChanged: controller.updateTitle,
                        initialValue: controller.title.isEmpty ? null : controller.title,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          hintText: 'タイトル',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 400,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        scrollPadding: const EdgeInsets.all(0),
                        onChanged: controller.updateContent,
                        initialValue: controller.content.isEmpty ? null : controller.content,
                        decoration: const InputDecoration(
                          isDense: true, // 改行時にも場所を固定したい場合は true にする。
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          hintText: '感想を書いてみませんか？',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget aromaButton(Aroma aroma, ReviewController controller) {
    return EasyButton(
      padding: 2,
      onPressed: () =>
          controller.aromaList.contains(aroma) ? controller.removeAroma(aroma) : controller.addAroma(aroma),
      onPrimary: controller.aromaList.contains(aroma) ? Colors.white : Colors.black,
      primary: controller.aromaList.contains(aroma) ? Colors.blue : Colors.white,
      text: aromaText(aroma),
    );
  }

  String aromaText(Aroma aroma) {
    switch (aroma) {
      case Aroma.choco:
        return 'チョコ';
      case Aroma.fruity:
        return 'フルーティ';
      case Aroma.honey:
        return 'ハニー';
      case Aroma.malty:
        return 'モルティ';
      case Aroma.nutty:
        return 'ナッツ';
      case Aroma.smoky:
        return 'スモーキー';
      case Aroma.vanilla:
        return 'バニラ';
      case Aroma.woody:
        return 'ウッディ';
    }
  }

  Widget howToDrinkButton(HowToDrink howToDrink, ReviewController controller) {
    return EasyButton(
      padding: 2,
      onPressed: () => controller.howToDrinkList.contains(howToDrink)
          ? controller.removeHowToDrink(howToDrink)
          : controller.addHowToDrink(howToDrink),
      onPrimary: controller.howToDrinkList.contains(howToDrink) ? Colors.white : Colors.black,
      primary: controller.howToDrinkList.contains(howToDrink) ? Colors.blue : Colors.white,
      text: howToDrinkText(howToDrink),
    );
  }

  String howToDrinkText(HowToDrink howToDrink) {
    switch (howToDrink) {
      case HowToDrink.rock:
        return 'ロック';
      case HowToDrink.soda:
        return 'ハイボール';
      case HowToDrink.straight:
        return 'ストレート';
      case HowToDrink.water:
        return '水割り';
    }
  }
}
