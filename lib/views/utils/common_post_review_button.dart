import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/views/post_review_page.dart';
import 'package:whiskit/views/utils/easy_button.dart';

class CommonPostReviewButton extends ConsumerWidget {
  const CommonPostReviewButton({required this.whiskyId, required this.onTap});
  final String whiskyId;

  // 投稿が成功した時に呼ばれる関数
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(userProvider);
    return EasyButton(
      onPressed: controller.user == null
          ? null
          : () async {
              final ret = await Navigator.pushNamed(
                context,
                '${PostReviewPage.route}/$whiskyId',
              );
              if (ret == true) {
                onTap();
              }
            },
      primary: Colors.white,
      onPrimary: Theme.of(context).scaffoldBackgroundColor,
      text: '感想を書く',
    );
  }
}
