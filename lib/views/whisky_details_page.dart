import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whiskit/controllers/whisky_details_controller.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/utils/common_post_review_button.dart';
import 'package:whiskit/views/utils/common_user_icon.dart';
import 'package:whiskit/views/utils/common_whisky_image.dart';
import 'package:whiskit/views/utils/common_whisky_info.dart';
import 'package:whiskit/views/utils/easy_button.dart';

class WhiskyDetailsPage extends ConsumerWidget {
  const WhiskyDetailsPage({Key? key, required this.whiskyId}) : super(key: key);
  final String whiskyId;
  static const route = '/details';
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(whiskyDetailsProvider(whiskyId));
    final whisky = controller.whisky;
    final textTheme = Theme.of(context).textTheme;
    final textStyle = TextStyle(color: Theme.of(context).colorScheme.secondary);
    if (whisky == null) {
      return const Scaffold();
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          alignment: Alignment.topLeft,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(MainPage.route);
                  },
                  child: Text('WHISKIT', style: textTheme.headline6),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: CommonPostReviewButton(
              whiskyId: whiskyId,
              onTap: () async {
                await controller.fetchReview();
              },
            ),
          ),
          CommonUserIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16, width: double.infinity),
            SizedBox(
              height: 200,
              child: CommonWhiskyImage(imageUrl: whisky.imageUrl),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: CommonWhiskyInfo(whisky: whisky, center: true),
            ),
            const SizedBox(height: 48),

            /// 香り上位 3 つまでを表示する
            const Text(
              '香り',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.aromaCountList.isNotEmpty)
                  ...controller.aromaCountList.map(
                    (e) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          e.name,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const Text('レビューはまだありません')
              ],
            ),
            const SizedBox(height: 64),
            SizedBox(
              height: 280,
              width: 280,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  VerticalDivider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Positioned(
                    right: -64,
                    child: SizedBox(
                      width: 56,
                      child: Text('濃厚', style: textStyle),
                    ),
                  ),
                  Positioned(
                    left: -64,
                    child: SizedBox(
                      width: 56,
                      child: Text(
                        'スッキリ',
                        textAlign: TextAlign.right,
                        style: textStyle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -24,
                    child: Text('あまい', style: textStyle),
                  ),
                  Positioned(
                    bottom: -24,
                    child: Text(
                      'スパイシー',
                      textAlign: TextAlign.start,
                      style: textStyle,
                    ),
                  ),
                  if (controller.displayGraph)
                    Align(
                      alignment: Alignment(
                        (whisky.richAverage - 3) / 2,
                        -(whisky.sweetAverage - 3) / 2,
                      ),
                      child: const Icon(Icons.star),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                amazonButton(whisky),
                const SizedBox(width: 16),
                rakutenButton(whisky),
              ],
            ),
            const SizedBox(height: 64),
            if (controller.reviewList.isNotEmpty)
              ...controller.reviewList.map(
                (review) {
                  return Container(
                    height: 200,
                    width: 400,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ReviewWidget(initReview: review, displayImage: false),
                  );
                },
              ).toList()
          ],
        ),
      ),
    );
  }
}
