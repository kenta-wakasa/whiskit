import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/review_controller.dart';
import 'package:whiskit/models/review.dart';


class ReviewWidget extends ConsumerWidget {
  const ReviewWidget({Key? key, required this.initReview, this.displayImage = false}) : super(key: key);
  final Review initReview;
  final bool displayImage;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final textTheme = Theme.of(context).textTheme;
    final controller = watch(reviewProvider(initReview));
    final review = controller.review;
    final image = displayImage
        ? FadeInImage.memoryNetwork(
            fit: BoxFit.fitHeight,
            fadeInDuration: const Duration(milliseconds: 400),
            placeholder: kTransparentImage,
            image: review.imageUrl,
          )
        : const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(review.user.avatarUrl),
                ),
                const SizedBox(height: 32),
                Expanded(child: image),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
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
