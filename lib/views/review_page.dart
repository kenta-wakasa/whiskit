import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/review_controller.dart';
import '/models/review.dart';
import '/views/utils/easy_button.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({required this.whiskyId});
  static const route = '/review';
  final String whiskyId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final textTheme = Theme.of(context).textTheme;
    final controller = watch(reviewProvider);

    final hasFruity = controller.aromaList.contains(Aroma.fruity);
    final hasMalty = controller.aromaList.contains(Aroma.malty);
    final hasChoco = controller.aromaList.contains(Aroma.choco);
    final hasNutty = controller.aromaList.contains(Aroma.nutty);
    final hasWoody = controller.aromaList.contains(Aroma.woody);
    final hasSmoky = controller.aromaList.contains(Aroma.smoky);
    final hasVanilla = controller.aromaList.contains(Aroma.vanilla);

    final hasRock = controller.howToDrinkList.contains(HowToDrink.rock);
    final hasSoda = controller.howToDrinkList.contains(HowToDrink.soda);
    final hasStraight = controller.howToDrinkList.contains(HowToDrink.straight);
    final hasWater = controller.howToDrinkList.contains(HowToDrink.water);

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
              onPressed: () {},
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
                    Wrap(children: [
                      EasyButton(
                        padding: 2,
                        onPressed: () => hasRock
                            ? controller.removeHowToDrink(HowToDrink.rock)
                            : controller.addHowToDrink(HowToDrink.rock),
                        onPrimary: hasRock ? Colors.white : Colors.black,
                        primary: hasRock ? Colors.blue : Colors.white,
                        text: 'ロック',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () => hasSoda
                            ? controller.removeHowToDrink(HowToDrink.soda)
                            : controller.addHowToDrink(HowToDrink.soda),
                        onPrimary: hasSoda ? Colors.white : Colors.black,
                        primary: hasSoda ? Colors.blue : Colors.white,
                        text: 'ハイボール',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () => hasStraight
                            ? controller.removeHowToDrink(HowToDrink.straight)
                            : controller.addHowToDrink(HowToDrink.straight),
                        onPrimary: hasStraight ? Colors.white : Colors.black,
                        primary: hasStraight ? Colors.blue : Colors.white,
                        text: 'ストレート',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () => hasWater
                            ? controller.removeHowToDrink(HowToDrink.water)
                            : controller.addHowToDrink(HowToDrink.water),
                        onPrimary: hasWater ? Colors.white : Colors.black,
                        primary: hasWater ? Colors.blue : Colors.white,
                        text: '水割り',
                      ),
                    ]),
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
                    Wrap(children: [
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasFruity ? controller.removeAroma(Aroma.fruity) : controller.addAroma(Aroma.fruity),
                        onPrimary: hasFruity ? Colors.white : Colors.black,
                        primary: hasFruity ? Colors.blue : Colors.white,
                        text: 'フルーティ',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasMalty ? controller.removeAroma(Aroma.malty) : controller.addAroma(Aroma.malty),
                        onPrimary: hasMalty ? Colors.white : Colors.black,
                        primary: hasMalty ? Colors.blue : Colors.white,
                        text: 'モルティ',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasSmoky ? controller.removeAroma(Aroma.smoky) : controller.addAroma(Aroma.smoky),
                        onPrimary: hasSmoky ? Colors.white : Colors.black,
                        primary: hasSmoky ? Colors.blue : Colors.white,
                        text: 'スモーキー',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasChoco ? controller.removeAroma(Aroma.choco) : controller.addAroma(Aroma.choco),
                        onPrimary: hasChoco ? Colors.white : Colors.black,
                        primary: hasChoco ? Colors.blue : Colors.white,
                        text: 'チョコ',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasVanilla ? controller.removeAroma(Aroma.vanilla) : controller.addAroma(Aroma.vanilla),
                        onPrimary: hasVanilla ? Colors.white : Colors.black,
                        primary: hasVanilla ? Colors.blue : Colors.white,
                        text: 'バニラ',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasNutty ? controller.removeAroma(Aroma.nutty) : controller.addAroma(Aroma.nutty),
                        onPrimary: hasNutty ? Colors.white : Colors.black,
                        primary: hasNutty ? Colors.blue : Colors.white,
                        text: 'ナッツ',
                      ),
                      EasyButton(
                        padding: 2,
                        onPressed: () =>
                            hasWoody ? controller.removeAroma(Aroma.woody) : controller.addAroma(Aroma.woody),
                        onPrimary: hasWoody ? Colors.white : Colors.black,
                        primary: hasWoody ? Colors.blue : Colors.white,
                        text: 'ウッディ',
                      ),
                    ]),
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
}
