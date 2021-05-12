import 'package:flutter/material.dart';
import 'package:whiskit/models/whisky.dart';

class CommonWhiskyInfo extends StatelessWidget {
  const CommonWhiskyInfo({
    required this.whisky,
    this.center = false,
  });
  final Whisky whisky;
  final bool center;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          whisky.name,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headline6,
          maxLines: 1,
        ),
        const Divider(),
        Text(
          'Age: ${whisky.age == 0 ? '-' : whisky.age}   '
          'Alcohol: ${whisky.alcohol}   '
          'Style: ${whisky.style}',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
