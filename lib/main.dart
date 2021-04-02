import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whiskit/configure_web.dart';
import 'package:whiskit/utils/hex_color.dart';

import 'views/whisky_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureApp();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MainPage();
        }
        return Loading();
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WHISKIT',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: HexColor('000028'),
          appBarTheme: AppBarTheme(backgroundColor: HexColor('000028')),
          textTheme: const TextTheme(
            headline6: TextStyle(fontWeight: FontWeight.bold),
          )),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const WhiskyListPage(),
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('サーバーとの接続に失敗しました')),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('起動準備中...')),
      ),
    );
  }
}
