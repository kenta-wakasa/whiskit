import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/search_controller.dart';
import 'package:whiskit/controllers/whisky_list_controller.dart';

class SearchForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(searchProvider);
    return SizedBox(
      height: 32,
      child: TextFormField(
        key: const ValueKey('Search'),
        onChanged: (text) {
          controller.search(
            whiskyList: context.read(whiskyProvider).whiskyList,
            searchToText: text,
          );
        },
        style: const TextStyle(fontSize: 12),
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32)), gapPadding: 0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 16,
          ),
          hintText: '名前で調べる...',
          contentPadding: EdgeInsets.all(0),
        ),
      ),
    );
  }
}
