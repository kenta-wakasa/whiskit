import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/post_review_controller.dart';
import 'package:whiskit/controllers/search_controller.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/controllers/whisky_details_controller.dart';
import 'package:whiskit/controllers/whisky_list_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/views/home_page.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/post_review_page.dart';
import 'package:whiskit/views/review_widget.dart';
import 'package:whiskit/views/utils/common_widget.dart';
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
          InkWell(
            onTap: () {
              // サインインしていない
              if (context.read(userProvider).user == null) {
                // TODO: sign in をうながすダイアログを出すなど

              }
              // サインインしている
              else {
                Navigator.pushNamed(context, HomePage.route);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Consumer(
                  builder: (_, watch, __) {
                    final user = watch(userProvider).user;
                    if (user == null) {
                      return const Icon(Icons.account_circle_rounded);
                    }
                    return CircleAvatar(foregroundImage: NetworkImage(user.avatarUrl));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
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
                    Expanded(
                      flex: 1,
                      child: FadeInImage.memoryNetwork(
                        fadeInDuration: const Duration(milliseconds: 320),
                        placeholder: kTransparentImage,
                        image: whisky.imageUrl,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: FutureBuilder(
                        future: ReviewRepository.instance.fetchFirstReview(whiskyId: whisky.ref.id),
                        builder: (context, AsyncSnapshot<Review> snapshot) {
                          final reviewWidget = (snapshot.connectionState == ConnectionState.waiting)
                              ? Center(child: progressIndicator())
                              : (snapshot.data == null)
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
                            child: reviewWidget,
                          );
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
                          : () {
                              Navigator.pushNamed(
                                context,
                                '${PostReviewPage.route}/${whisky.ref.id}',
                              );
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
