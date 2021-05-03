import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/review_controller.dart';

import '/models/review.dart';

class ReviewWidget extends ConsumerWidget {
  const ReviewWidget({Key? key, required this.initReview}) : super(key: key);
  final Review initReview;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final textTheme = Theme.of(context).textTheme;
    final controller = watch(reviewProvider(initReview));
    final review = controller.review;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircleAvatar(
              foregroundImage: NetworkImage(review.user.avatarUrl),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 4),
                Text(
                  review.title,
                  style: textTheme.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    review.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: controller.changeFavorite,
                      icon: controller.exitsFavorite == true
                          ? const Icon(Icons.favorite_rounded, size: 20)
                          : const Icon(Icons.favorite_border_rounded, size: 20),
                      label: Text('${review.favoriteCount}'),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
