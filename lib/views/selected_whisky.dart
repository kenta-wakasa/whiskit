import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/review.dart';

import '/controllers/review_controller.dart';
import '/models/whisky.dart';
import '/views/main_page.dart';
import '/views/review_page.dart';
import '/views/utils/easy_button.dart';
import '/views/whisky_details_page.dart';
import 'utils/common_widget.dart';

class SelectedWhisky extends StatelessWidget {
  const SelectedWhisky({Key? key, required this.selectedWhisky}) : super(key: key);

  final Whisky selectedWhisky;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '${WhiskyDetailsPage.route}/${selectedWhisky.ref.id}',
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
                  image: selectedWhisky.imageUrl,
                ),
              ),
              SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedWhisky.name,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline6,
                      maxLines: 1,
                    ),
                    const Divider(color: Colors.white, height: 8),
                    Text(
                      'Age: ${selectedWhisky.age == 0 ? '-' : selectedWhisky.age}   '
                      'Alcohol: ${selectedWhisky.alcohol}   '
                      'Style: ${selectedWhisky.style}',
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
                      future: context.read(reviewProvider(selectedWhisky.ref.id)).fetchFirstReview(),
                      builder: (context, AsyncSnapshot<Review> snapshot) {
                        final reviewWidget = (snapshot.connectionState == ConnectionState.waiting)
                            ? Center(child: progressIndicator())
                            : (snapshot.data == null)
                            ? const Center(child: Text('レビューはまだありません'))
                            : Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircleAvatar(
                                        foregroundImage: NetworkImage(snapshot.data!.user.avatarUrl),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 4),
                                          Text(
                                            snapshot.data!.title,
                                            style: textTheme.bodyText1,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Expanded(child: Text(snapshot.data!.content)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );

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
                          return EasyButton(
                            onPressed: user == null
                                ? null
                                : () => Navigator.pushNamed(
                                      context,
                                      '${ReviewPage.route}/${selectedWhisky.ref.id}',
                                    ),
                            primary: Colors.white,
                            onPrimary: Theme.of(context).scaffoldBackgroundColor,
                            text: '感想を書く',
                          );
                        }),
                        const Spacer(),
                        EasyButton(
                          onPressed:
                              selectedWhisky.rakuten == '-' ? null : () => window.open(selectedWhisky.rakuten, ''),
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          text: '楽天',
                        ),
                        const SizedBox(width: basePadding),
                        EasyButton(
                          onPressed: selectedWhisky.amazon == '-' ? null : () => window.open(selectedWhisky.amazon, ''),
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
