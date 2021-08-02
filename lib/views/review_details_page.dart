import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/models/whisky.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/pop_up_notification_menu.dart';
import 'package:whiskit/views/utils/common_user_icon.dart';
import 'package:whiskit/views/utils/common_whisky_image.dart';
import 'package:whiskit/views/utils/common_whisky_info.dart';
import 'package:whiskit/views/utils/common_widget.dart';
import 'package:whiskit/views/utils/easy_button.dart';

class ReviewDetailsPage extends StatefulWidget {
  const ReviewDetailsPage({required this.reviewRef, required this.whiskyId});
  static const route = '/review';
  final DocumentReference reviewRef;
  final String whiskyId;

  @override
  State<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  Review? review;
  Whisky? whisky;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReview();
    fetchWhisky();
  }

  Future<void> fetchReview() async {
    try {
      final doc = await widget.reviewRef.get();
      review = await Review.fromDoc(doc);
      if (mounted) {
        setState(() {});
      }
    } on Exception catch (_) {
      // リダイレクトのやり方:参考 https://stackoverflow.com/questions/55618717/error-thrown-on-navigator-pop-until-debuglocked-is-not-true
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed(MainPage.route);
      });
    }
  }

  Future<void> fetchWhisky() async {
    try {
      whisky = await WhiskyRepository.instance.fetchWhiskyById(widget.whiskyId);
      if (mounted) {
        setState(() {});
      }
    } on Exception catch (_) {
      // リダイレクトのやり方:参考 https://stackoverflow.com/questions/55618717/error-thrown-on-navigator-pop-until-debuglocked-is-not-true
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed(MainPage.route);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final review = this.review;
    final whisky = this.whisky;
    if (review == null || whisky == null) {
      return const SizedBox.shrink();
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
                logo(context),
              ],
            ),
          ],
        ),
        actions: [
          PopUpNotificationMenu(),
          CommonUserIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
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
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  amazonButton(whisky),
                  const SizedBox(width: 16),
                  rakutenButton(whisky),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const Divider(),
                    Text(review.content),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
