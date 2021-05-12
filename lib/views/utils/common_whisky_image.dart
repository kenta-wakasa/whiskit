import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CommonWhiskyImage extends StatelessWidget {
  const CommonWhiskyImage({required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      fadeInDuration: const Duration(milliseconds: 400),
      placeholder: kTransparentImage,
      image: imageUrl,
    );
  }
}
