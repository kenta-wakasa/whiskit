import 'dart:html';

import 'package:flutter/material.dart';

import '../models/whisky.dart';

class WhiskyListPage extends StatefulWidget {
  const WhiskyListPage({Key? key}) : super(key: key);

  @override
  _WhiskyListPageState createState() => _WhiskyListPageState();
}

class _WhiskyListPageState extends State<WhiskyListPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final basePadding = width / 80;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text('WHISKIT', style: textTheme.headline6)],
        ),
      ),
      body: whiskyList.isEmpty
          ? const SizedBox()
          : Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(basePadding),
                      height: width / 4,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Stack(
                          children: [
                            AnimatedOpacity(
                              opacity: selectedWhisky == null ? 1 : 0,
                              duration: const Duration(milliseconds: 500),
                              child: const Text('今日はどうしましょうか？'),
                            ),
                            selectedWhisky == null
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: basePadding * 2),
                                      Image.network(selectedWhisky!.imageUrl),
                                      SizedBox(width: basePadding * 2),
                                      SizedBox(
                                        width: width / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(selectedWhisky!.name, style: textTheme.headline6),
                                            const Divider(color: Colors.white),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: width / 6,
                                                  child: Text(
                                                    'Age: ${selectedWhisky!.age ?? '-'}',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width / 6,
                                                  child: Text(
                                                    'Alcohol: ${selectedWhisky!.alcohol}',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width / 6,
                                                  child: Text(
                                                    'Style: ${selectedWhisky!.style}',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Expanded(child: SizedBox()),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: selectedWhisky!.rakuten == '-'
                                                      ? null
                                                      : () => window.open(selectedWhisky!.rakuten, ''),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    onPrimary: Colors.white,
                                                    shape: const StadiumBorder(),
                                                  ),
                                                  child: const Text('楽天'),
                                                ),
                                                SizedBox(width: basePadding),
                                                ElevatedButton(
                                                  onPressed: selectedWhisky!.amazon == '-'
                                                      ? null
                                                      : () => window.open(selectedWhisky!.amazon, ''),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.orangeAccent[700],
                                                    onPrimary: Colors.white,
                                                    shape: const StadiumBorder(),
                                                  ),
                                                  child: const Text('Amazon'),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: basePadding * 2),
                      child: SizedBox(
                        height: 400,
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: basePadding,
                              mainAxisSpacing: basePadding * 2,
                              crossAxisCount: 10,
                              childAspectRatio: 2 / 5,
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
                ),
              ),
            ),
    );
  }

  List<Whisky> whiskyList = [];
  Whisky? selectedWhisky;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void selectWhisky(Whisky whisky) {
    selectedWhisky = whisky;
    setState(() {});
  }

  Future<void> fetch() async {
    whiskyList = await WhiskyRepository.instance.fetchWhiskyList();
    setState(() {});
  }
}
