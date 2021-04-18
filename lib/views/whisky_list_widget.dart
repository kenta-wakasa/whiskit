import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

import '/controllers/whisky_controller.dart';
import '/views/selected_whisky.dart';

class WhiskyListWidget extends ConsumerWidget {
  const WhiskyListWidget({Key? key, required this.basePadding}) : super(key: key);

  final double basePadding;

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
                basePadding: basePadding,
                selectedWhisky: selectedWhisky,
              ),
        const Divider(color: Colors.white),
        SizedBox(
          key: UniqueKey(),
          height: MediaQuery.of(context).size.height / 4,
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
