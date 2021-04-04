import 'package:flutter/material.dart';

class WhiskyDetailsPage extends StatelessWidget {
  const WhiskyDetailsPage({Key? key, required this.whiskyId}) : super(key: key);
  final String whiskyId;
  static const route = '/details';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Center(child: Text(whiskyId)),
      ),
    );
  }
}
