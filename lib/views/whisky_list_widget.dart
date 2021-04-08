import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whiskit/views/whisky_details_page.dart';

import '../models/whisky.dart';

class WhiskyListWidget extends StatefulWidget {
  const WhiskyListWidget({Key? key}) : super(key: key);

  @override
  _WhiskyListWidgetState createState() => _WhiskyListWidgetState();
}

class _WhiskyListWidgetState extends State<WhiskyListWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final maxLength = max(width, height);
    final basePadding = maxLength / 80;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxLength / 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: [
                selectedWhisky == null
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: basePadding * 2),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '${WhiskyDetailsPage.route}/${selectedWhisky!.id}',
                            ),
                            child: Image.network(selectedWhisky!.imageUrl),
                          ),
                          SizedBox(width: basePadding * 2),
                          SizedBox(
                            width: maxLength * 0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  selectedWhisky!.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.headline6,
                                  maxLines: 1,
                                ),
                                const Divider(color: Colors.white),
                                Text(
                                  'Age: ${selectedWhisky!.age ?? '-'}   '
                                  'Alcohol: ${selectedWhisky!.alcohol}   '
                                  'Style: ${selectedWhisky!.style}',
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
                                        onPressed: selectedWhisky!.rakuten == '-'
                                            ? null
                                            : () => window.open(selectedWhisky!.rakuten, ''),
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
                                        onPressed: selectedWhisky!.amazon == '-'
                                            ? null
                                            : () => window.open(selectedWhisky!.amazon, ''),
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
        ),
        const Divider(color: Colors.white),
        SizedBox(
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
                itemCount: whiskyList.length,
                itemBuilder: (BuildContext context, int index) {
                  final whisky = whiskyList[index];
                  return InkWell(
                    onTap: () => selectWhisky(whisky),
                    child: Image.network(whisky.imageUrl),
                  );
                }),
          ),
        ),
      ],
    );
  }

  List<Whisky> whiskyList = [];
  Whisky? selectedWhisky;

  @override
  void initState() {
    super.initState();
    fetchWhiskyList();
  }

  void selectWhisky(Whisky whisky) {
    selectedWhisky = whisky;
    setState(() {});
  }

  Future<void> fetchWhiskyList() async {
    whiskyList = await WhiskyRepository.instance.fetchWhiskyList()
      ..shuffle();
    selectWhisky(whiskyList[Random().nextInt(whiskyList.length)]);
  }
}
