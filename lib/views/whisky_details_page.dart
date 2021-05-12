import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whiskit/controllers/whisky_details_controller.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/utils/common_user_icon.dart';
import 'package:whiskit/views/utils/common_whisky_image.dart';
import 'package:whiskit/views/utils/common_whisky_info.dart';

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
        actions: [CommonUserIcon()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            SizedBox(
              height: 200,
              child: CommonWhiskyImage(imageUrl: whisky.imageUrl),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: CommonWhiskyInfo(whisky: whisky, center: true),
            ),
          ],
        ),
      ),
    );
  }
}
