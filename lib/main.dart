// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:whiskit/utils/hex_color.dart';
import 'package:whiskit/views/home_page.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/post_review_page.dart';
import 'package:whiskit/views/whisky_details_page.dart';

/// flutter run -d chrome --web-hostname localhost --web-port 5000 --web-renderer html
/// flutter build web --web-renderer html でビルドすること
/// firebase deploy --only hosting でデプロイ。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // キャッシュの有効化
  // await FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));

  // Url から # を取り除くための設定
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp();
  await FirebaseAuth.instance.userChanges().first;

  runApp(ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = HexColor('000028');
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        headline5: TextStyle(fontWeight: FontWeight.bold),
        headline6: TextStyle(fontWeight: FontWeight.bold),
      ),
      dividerTheme: const DividerThemeData(thickness: .5, color: Colors.white),
      primarySwatch: Colors.blue,
    );
    return MaterialApp(
      title: 'WHISKIT｜ウィスキー選びをもっとおもしろく',
      theme: baseTheme.copyWith(
        colorScheme: baseTheme.colorScheme.copyWith(secondary: Colors.blue),
      ),
      initialRoute: MainPage.route,

      /// 動的なルーティングはここでおこなう
      onGenerateRoute: (settings) {
        if (settings.name!.split('/')[1] == WhiskyDetailsPage.route.substring(1) &&
            settings.name!.split('/').length == 3) {
          final arg = settings.name!.split('/')[2];
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => WhiskyDetailsPage(whiskyId: arg),
          );
        }

        if (FirebaseAuth.instance.currentUser != null) {
          if (settings.name!.split('/')[1] == PostReviewPage.route.substring(1) && settings.name!.split('/').length == 3) {
            final arg = settings.name!.split('/')[2];
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => PostReviewPage(whiskyId: arg),
            );
          }

          if (settings.name!.split('/')[1] == HomePage.route.substring(1)) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const HomePage(),
            );
          }
        }

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => const MainPage(key: ValueKey('main')),
        );
      },
    );
  }
}
