// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/review.dart';
import 'package:whiskit/utils/hex_color.dart';
import 'package:whiskit/views/home_page.dart';
import 'package:whiskit/views/main_page.dart';
import 'package:whiskit/views/post_review_page.dart';
import 'package:whiskit/views/review_details_page.dart';
import 'package:whiskit/views/whisky_details_page.dart';

/// flutter run -d chrome --web-hostname localhost --web-port 5000 --web-renderer html
/// flutter build web --web-renderer html でビルドすること
/// firebase deploy --only hosting でデプロイ
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // キャッシュの有効化
  // await FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));

  // Url から # を取り除くための設定
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp();
  await FirebaseAuth.instance.authStateChanges().first;

  runApp(ProviderScope(child: Main()));
}

class Main extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final backgroundColor = HexColor('000028');
    watch(userProvider);
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(thickness: .5, color: Colors.white),
      primarySwatch: Colors.blue,
    );
    return MaterialApp(
      title: 'WHISKIT｜ウィスキー選びをもっとおもしろく',
      theme: baseTheme.copyWith(
        colorScheme: baseTheme.colorScheme.copyWith(secondary: Colors.blue),
        textTheme: GoogleFonts.notoSansTextTheme(
          baseTheme.textTheme.copyWith(
            bodyText1: baseTheme.textTheme.bodyText1!.copyWith(fontSize: 18),
            bodyText2: baseTheme.textTheme.bodyText2!.copyWith(fontSize: 14),
            headline5: baseTheme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
            headline6: baseTheme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
      initialRoute: MainPage.route,

      /// 動的なルーティングはここでおこなう
      onGenerateRoute: (settings) {
        if (settings.name!.split('/')[1] == WhiskyDetailsPage.route.substring(1) &&
            settings.name!.split('/').length == 3) {
          final arg = settings.name!.split('/')[2];
          return NoAnimationMaterialPageRoute<void>(
            settings: settings,
            builder: (context) => WhiskyDetailsPage(whiskyId: arg),
          );
        }

        if (settings.name!.split('/')[1] == ReviewDetailsPage.route.substring(1) &&
            settings.name!.split('/').length == 4) {
          final whiskyId = settings.name!.split('/')[2];
          final reviewId = settings.name!.split('/')[3];
          final reviewRef = ReviewRepository.instance.collectionRef(whiskyId: whiskyId).doc(reviewId);
          return NoAnimationMaterialPageRoute<void>(
            settings: settings,
            builder: (context) => ReviewDetailsPage(reviewRef: reviewRef, whiskyId: whiskyId),
          );
        }

        /// 認証が済んでいるか
        if (FirebaseAuth.instance.currentUser != null) {
          if (settings.name!.split('/')[1] == PostReviewPage.route.substring(1) &&
              settings.name!.split('/').length == 3) {
            final arg = settings.name!.split('/')[2];
            return NoAnimationMaterialPageRoute<void>(
              settings: settings,
              builder: (context) => PostReviewPage(whiskyId: arg),
            );
          }

          if (settings.name!.split('/')[1] == HomePage.route.substring(1)) {
            return NoAnimationMaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const HomePage(),
            );
          }
        }

        return NoAnimationMaterialPageRoute<void>(
          settings: settings,
          builder: (context) => const MainPage(key: ValueKey('main')),
        );
      },
    );
  }
}

/// アニメーションのないMaterialPageRoute
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(builder: builder, maintainState: maintainState, settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
