import 'package:flutter/material.dart';

import '../models/whisky.dart';

class WhiskyDetailsPage extends StatelessWidget {
  const WhiskyDetailsPage({Key? key, required this.whisky}) : super(key: key);
  final Whisky whisky;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network(whisky.imageUrl)),
    );
  }
}
