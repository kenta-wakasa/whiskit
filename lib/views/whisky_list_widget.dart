import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import '/controllers/whisky_controller.dart';
import '/views/selected_whisky.dart';

class WhiskyListWidget extends ConsumerWidget {
  const WhiskyListWidget({
    Key? key,
    required this.basePadding,
    required this.maxLength,
    required this.textTheme,
  }) : super(key: key);

  final double maxLength;
  final double basePadding;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(whiskyProvider);
    final whiskyList = controller.whiskyList;
    final selectedWhisky = controller.selectedWhisky;
    if (whiskyList == null && selectedWhisky == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        selectedWhisky == null
            ? const SizedBox()
            : SelectedWhisky(
                maxLength: maxLength,
                basePadding: basePadding,
                selectedWhisky: selectedWhisky,
                textTheme: textTheme,
              ),
        const Divider(color: Colors.white),
        SizedBox(
          key: UniqueKey(),
          height: maxLength / 4,
          child: Scrollbar(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: basePadding,
                mainAxisSpacing: basePadding * 2,
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
