import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/post_review_controller.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/models/whisky.dart';
import 'package:whiskit/views/post_review_page.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/utils/common_widget.dart';
import 'package:whiskit/views/utils/easy_button.dart';
import 'package:whiskit/views/whisky_details_page.dart';

class SelectedWhisky extends StatefulWidget {
  const SelectedWhisky({Key? key, required this.selectedWhisky}) : super(key: key);

  final Whisky selectedWhisky;

  @override
  _SelectedWhiskyState createState() => _SelectedWhiskyState();
}

class _SelectedWhiskyState extends State<SelectedWhisky> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '${WhiskyDetailsPage.route}/${widget.selectedWhisky.ref.id}',
      ),
      child: SizedBox(
        height: 300,
        width: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiskyInfo(context, widget.selectedWhisky),
                  const SizedBox(height: 8),
                  Text(
                    '新着レビュー',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 2),
                  FutureBuilder(
                    future: ReviewRepository.instance.fetchFirstReview(whiskyId: widget.selectedWhisky.ref.id),
                    builder: (context, AsyncSnapshot<Review> snapshot) {
                      final reviewWidget = (snapshot.connectionState == ConnectionState.waiting)
                          ? Center(child: progressIndicator())
                          : (snapshot.data == null)
                              ? const Center(child: Text('レビューはまだありません'))
                              : ReviewWidget(initReview: snapshot.data!);

                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
                            ),
                          ),
                          child: reviewWidget,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer(builder: (_, watch, __) {
                        final user = watch(userProvider).user;
                        watch(postReviewProvider(widget.selectedWhisky.ref.id));
                        return EasyButton(
                          onPressed: user == null
                              ? null
                              : () async {
                                  await Navigator.pushNamed(
                                    context,
                                    '${PostReviewPage.route}/${widget.selectedWhisky.ref.id}',
                                  );
                                  setState(() {});
                                },
                          primary: Colors.white,
                          onPrimary: Theme.of(context).scaffoldBackgroundColor,
                          text: '感想を書く',
                        );
                      }),
                      const Spacer(),
                      rakutenButton(widget.selectedWhisky),
                      const SizedBox(width: 8),
                      amazonButton(widget.selectedWhisky),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: FadeInImage.memoryNetwork(
                fadeInDuration: const Duration(milliseconds: 320),
                placeholder: kTransparentImage,
                image: widget.selectedWhisky.imageUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
