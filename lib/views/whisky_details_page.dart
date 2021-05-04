import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whiskit/controllers/whisky_details_controller.dart';

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
      body: Center(
        child: FadeInImage.memoryNetwork(
          fadeInDuration: const Duration(milliseconds: 320),
          placeholder: kTransparentImage,
          image: whisky.imageUrl,
        ),
      ),
    );
  }
}
