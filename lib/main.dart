import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/flex_color_theme.dart';
import 'package:movie_app/src/common/use_init.dart';
import 'package:movie_app/src/ui/pages/favorite_movie_page.dart';

import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/ui/pages/home.dart';
import 'package:movie_repository/movie_repository.dart';

void main() async {
  runApp(const AppInitialisation());
}

class AppInitialisation extends HookWidget {
  const AppInitialisation({super.key});
  @override
  Widget build(BuildContext context) {
    final isInitFinied = useState(false);
    useInitState(() {
      Future.microtask(() async {
        await dotenv.load();
        await Hive.initFlutter();
        await HiveDB.init("FavoriteMovie");
        isInitFinied.value = true;
      });
    });
    if (!isInitFinied.value) {
      return const AppInitialisationWaitWidget();
    }
    return const ProviderScope(
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AppRouter.homePage: (ctx) => const Home(),
        AppRouter.favoriteMoviesNamePage: (ctx) => const FavoriteMovieList(),
      },
      initialRoute: AppRouter.homePage,
      onGenerateRoute: AppRouter.routes,
      debugShowCheckedModeBanner: false,
      darkTheme: darkFlex,
      theme: lightFlex,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('fr', ''), // French, no country code
      ],
    );
  }
}

class AppInitialisationWaitWidget extends StatelessWidget {
  const AppInitialisationWaitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("asset/launcher/cinema.png"),
    );
  }
}
