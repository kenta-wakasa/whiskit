import 'package:flutter/material.dart';
import 'package:whiskit/views/utils/easy_button.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({required this.whiskyId});
  static const route = '/review';
  final String whiskyId;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text('WHISKIT', style: textTheme.headline5)],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: EasyButton(
              primary: Colors.white,
              onPrimary: Colors.black,
              onPressed: () {},
              text: '投稿',
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      maxLines: 1,
                      style: textTheme.headline5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintText: 'タイトル',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 400,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      scrollPadding: const EdgeInsets.all(0),
                      decoration: const InputDecoration(
                        isDense: true, // 改行時にも場所を固定したい場合は true にする。
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintText: '感想を書いてみませんか？',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
