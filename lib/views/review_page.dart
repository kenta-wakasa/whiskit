import 'package:flutter/material.dart';

import '/views/utils/default_appbar.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({required this.whiskyId});
  static const route = '/review';
  final String whiskyId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context),
    );
  }
}
