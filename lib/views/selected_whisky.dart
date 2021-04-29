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

class SelectedWhisky extends StatelessWidget {
  const SelectedWhisky({required this.selectedWhisky});

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
                    FutureBuilder(
                      future: context.read(reviewProvider(selectedWhisky.ref.id)).fetchFirstReview(),
                      builder: (context, AsyncSnapshot<Review> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final review = snapshot.data;
                        if (review == null) {
                          return const SizedBox();
                        }
                        return Text(review.content);
                      },
                    ),
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
