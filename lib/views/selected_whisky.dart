import 'dart:html';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '/models/whisky.dart';
import '/views/whisky_details_page.dart';

class SelectedWhisky extends StatelessWidget {
  const SelectedWhisky({
    Key? key,
    required this.maxLength,
    required this.basePadding,
    required this.selectedWhisky,
    required this.textTheme,
  }) : super(key: key);

  final double maxLength;
  final double basePadding;
  final Whisky selectedWhisky;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final height = maxLength / 4;
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '${WhiskyDetailsPage.route}/${selectedWhisky.ref.id}',
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: basePadding * 2),
                    child: AspectRatio(
                      aspectRatio: 2 / 5,
                      child: FadeInImage.memoryNetwork(
                        fadeInDuration: const Duration(milliseconds: 400),
                        placeholder: kTransparentImage,
                        image: selectedWhisky.imageUrl,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: maxLength * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        selectedWhisky.name,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headline6,
                        maxLines: 1,
                      ),
                      const Divider(color: Colors.white),
                      Text(
                        'Age: ${selectedWhisky.age ?? '-'}   '
                        'Alcohol: ${selectedWhisky.alcohol}   '
                        'Style: ${selectedWhisky.style}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 80,
                            child: ElevatedButton(
                              onPressed:
                                  selectedWhisky.rakuten == '-' ? null : () => window.open(selectedWhisky.rakuten, ''),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              child: const SizedBox(
                                height: 16,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text('楽天'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: basePadding),
                          SizedBox(
                            height: 24,
                            width: 80,
                            child: ElevatedButton(
                              onPressed:
                                  selectedWhisky.amazon == '-' ? null : () => window.open(selectedWhisky.amazon, ''),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent[700],
                                onPrimary: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              child: const SizedBox(
                                height: 16,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text('Amazon'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
