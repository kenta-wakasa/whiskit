import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/post_review_controller.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/models/whisky.dart';
import 'package:whiskit/views/post_review_page.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/utils/common_whisky_imga.dart';
import 'package:whiskit/views/utils/common_widget.dart';
import 'package:whiskit/views/utils/easy_button.dart';
import 'package:whiskit/views/whisky_details_page.dart';

class SelectedWhisky extends StatefulWidget {
  const SelectedWhisky({Key? key, required this.whisky}) : super(key: key);

  final Whisky whisky;

  @override
  _SelectedWhiskyState createState() => _SelectedWhiskyState();
}

class _SelectedWhiskyState extends State<SelectedWhisky> {
  @override
  Widget build(BuildContext context) {
    final whisky = widget.whisky;
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '${WhiskyDetailsPage.route}/${whisky.ref.id}',
      ),
      child: SizedBox(
        height: 300,
        width: 400,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiskyInfo(context, whisky),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 1, child: CommonWhiskyImage(imageUrl: whisky.imageUrl)),
                    Expanded(
                      flex: 4,
                      child: FutureBuilder(
                        future: ReviewRepository.instance.fetchFirstReview(whiskyId: whisky.ref.id),
                        builder: (context, AsyncSnapshot<Review> snapshot) {
                          final reviewWidget = (snapshot.connectionState == ConnectionState.waiting)
                              ? const SizedBox.expand()
                              : snapshot.data == null
                                  ? const Center(child: Text('レビューはまだありません'))
                                  : ReviewWidget(initReview: snapshot.data!);

                          return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 160),
                                child: reviewWidget,
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer(builder: (_, watch, __) {
                    final user = watch(userProvider).user;
                    watch(postReviewProvider(whisky.ref.id));
                    return EasyButton(
                      onPressed: user == null
                          ? null
                          : () async {
                              await Navigator.pushNamed(
                                context,
                                '${PostReviewPage.route}/${whisky.ref.id}',
                              );
                              setState(() {});
                            },
                      primary: Colors.white,
                      onPrimary: Theme.of(context).scaffoldBackgroundColor,
                      text: '感想を書く',
                    );
                  }),
                  const Spacer(),
                  rakutenButton(whisky),
                  const SizedBox(width: 8),
                  amazonButton(whisky),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
