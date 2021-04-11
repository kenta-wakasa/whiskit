import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/utils/hex_color.dart';
import 'package:whiskit/views/whisky_details_page.dart';

import 'views/home_page.dart';

/// flutter run -d chrome --web-hostname localhost --web-port 5000 --web-renderer html
/// flutter build --web-renderer html でビルドすること
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Url から # を取り除くための設定
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp();
  // キャッシュの有効化
  await FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  runApp(ProviderScope(child: MainPage()));
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read(userProvider);
    final backgroundColor = HexColor('000028');
    return MaterialApp(
      title: 'WHISKIT｜ウィスキー選びをもっとおもしろく',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          headline5: TextStyle(fontWeight: FontWeight.bold),
          headline6: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: HomePage.route,

      /// 動的なルーティングはここでおこなう
      onGenerateRoute: (settings) {
        if (settings.name!.split('/')[1] == WhiskyDetailsPage.route.substring(1) &&
            settings.name!.split('/').length == 3) {
          final arg = settings.name!.split('/')[2];
          return MaterialPageRoute<bool>(
            settings: settings,
            builder: (context) => WhiskyDetailsPage(whiskyId: arg),
          );
        }
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (context) => const HomePage(),
        );
      },
    );
  }
}
