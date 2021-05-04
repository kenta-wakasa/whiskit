import 'package:flutter/material.dart';
import 'package:whiskit/models/whisky.dart';

Widget progressIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );
}

Widget whiskyInfo(BuildContext context, Whisky whisky) {
  final textTheme = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
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
