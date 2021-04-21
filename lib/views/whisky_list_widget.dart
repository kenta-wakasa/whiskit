import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import '/controllers/whisky_controller.dart';
import '/views/main_page.dart';
import '/views/selected_whisky.dart';

class WhiskyListWidget extends ConsumerWidget {
  const WhiskyListWidget();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(whiskyProvider);
    final whiskyList = controller.whiskyList;
    final selectedWhisky = controller.selectedWhisky;
    final selectedWhiskyWidget =
        selectedWhisky == null ? const SizedBox() : SelectedWhisky(selectedWhisky: selectedWhisky);

    if (whiskyList == null && selectedWhisky == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        selectedWhiskyWidget,
        const SizedBox(height: 16),
        SizedBox(
          key: UniqueKey(),
          height: 240,
          child: Scrollbar(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: basePadding,
                mainAxisSpacing: basePadding,
                crossAxisCount: 2,
                childAspectRatio: 5 / 2,
              ),
              itemCount: whiskyList!.length,
              itemBuilder: (BuildContext context, int index) {
                final whisky = whiskyList[index];
                return InkWell(
                  onTap: () => controller.select(whisky),
                  child: FadeInImage.memoryNetwork(
                    fadeInDuration: const Duration(milliseconds: 400),
                    placeholder: kTransparentImage,
                    image: whisky.imageUrl,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
