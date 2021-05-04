import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/review_controller.dart';

import '../controllers/post_review_controller.dart';
import '/controllers/user_controller.dart';
import '/models/review.dart';
import '/models/whisky.dart';
import '/views/main_page.dart';
import '/views/review_page.dart';
import '/views/review_widget.dart';
import '/views/utils/common_widget.dart';
import '/views/utils/easy_button.dart';
import '/views/whisky_details_page.dart';

class SelectedWhisky extends StatefulWidget {
  const SelectedWhisky({Key? key, required this.selectedWhisky}) : super(key: key);

  final Whisky selectedWhisky;

  @override
  _SelectedWhiskyState createState() => _SelectedWhiskyState();
}

class _SelectedWhiskyState extends State<SelectedWhisky> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '${WhiskyDetailsPage.route}/${widget.selectedWhisky.ref.id}',
      ),
      child: SizedBox(
        height: 240,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 5,
                child: FadeInImage.memoryNetwork(
                  fadeInDuration: const Duration(milliseconds: 400),
                  placeholder: kTransparentImage,
                  image: widget.selectedWhisky.imageUrl,
                ),
              ),
              SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.selectedWhisky.name,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline6,
                      maxLines: 1,
                    ),
                    const Divider(),
                    Text(
                      'Age: ${widget.selectedWhisky.age == 0 ? '-' : widget.selectedWhisky.age}   '
                      'Alcohol: ${widget.selectedWhisky.alcohol}   '
                      'Style: ${widget.selectedWhisky.style}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '新着レビュー',
                      style: TextStyle(color: Theme.of(context).accentColor),
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
                                color: Theme.of(context).accentColor.withOpacity(.2),
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
                                      '${ReviewPage.route}/${widget.selectedWhisky.ref.id}',
                                    );
                                    setState(() {});
                                  },
                            primary: Colors.white,
                            onPrimary: Theme.of(context).scaffoldBackgroundColor,
                            text: '感想を書く',
                          );
                        }),
                        const Spacer(),
                        EasyButton(
                          onPressed: widget.selectedWhisky.rakuten == '-'
                              ? null
                              : () => window.open(widget.selectedWhisky.rakuten, ''),
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          text: '楽天',
                        ),
                        const SizedBox(width: basePadding),
                        EasyButton(
                          onPressed: widget.selectedWhisky.amazon == '-'
                              ? null
                              : () => window.open(widget.selectedWhisky.amazon, ''),
                          primary: Colors.orangeAccent[700],
                          onPrimary: Colors.white,
                          text: 'Amazon',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
