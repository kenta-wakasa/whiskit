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
    final basePadding = MediaQuery.of(context).size.width / 80;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text('WHISKIT', style: textTheme.headline6)],
        ),
      ),
      body: whiskyList.isEmpty
          ? const CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: basePadding),
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
                    return Image.network(whisky.imageUrl);
                  }),
            ),
    );
  }

  List<Whisky> whiskyList = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    whiskyList = await WhiskyRepository.instance.fetchWhiskyList();
    setState(() {});
  }
}
