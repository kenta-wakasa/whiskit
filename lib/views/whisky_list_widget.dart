import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whiskit/controllers/whisky_list_controller.dart';
import 'package:whiskit/views/utils/common_whisky_image.dart';

class WhiskyListWidget extends ConsumerWidget {
  const WhiskyListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(whiskyProvider);
    final whiskyList = controller.whiskyList;

    if (whiskyList == null) {
      return const SizedBox();
    }
    return SizedBox(
      key: const ValueKey('WhiskyScroll'),
      height: 240,
      child: Scrollbar(
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            childAspectRatio: 5 / 2,
          ),
          itemCount: whiskyList.length,
          itemBuilder: (BuildContext context, int index) {
            final whisky = whiskyList[index];
            return InkWell(
              onTap: () => controller.select(whisky),
              child: CommonWhiskyImage(imageUrl: whisky.imageUrl),
            );
          },
        ),
      ),
    );
  }
}
