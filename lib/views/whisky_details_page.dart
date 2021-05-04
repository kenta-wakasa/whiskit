import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/whisky_details_controller.dart';
import 'package:whiskit/views/utils/common_widget.dart';

class WhiskyDetailsPage extends ConsumerWidget {
  const WhiskyDetailsPage({Key? key, required this.whiskyId}) : super(key: key);
  final String whiskyId;
  static const route = '/details';
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(whiskyDetailsProvider(whiskyId));
    final whisky = controller.whisky;
    if (whisky == null) {
      return const Scaffold();
    }
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: FadeInImage.memoryNetwork(
                    fadeInDuration: const Duration(milliseconds: 320),
                    placeholder: kTransparentImage,
                    image: whisky.imageUrl,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: whiskyInfo(context, whisky),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
