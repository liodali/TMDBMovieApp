import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/ui/component/item_movie.dart';
import 'package:movie_app/src/ui/widget/movie_image.dart';
import 'package:movie_app/src/ui/widget/note_movie.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  testWidgets("test Movie Item Widget", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemMovie(
            movie: Movie.fromJson(movieJson),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('fr', ''), // English, no country code
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("Suicide Squad"), findsOne);
    expect(find.byType(CachedNetworkImage), findsOne);
    expect(find.byType(MovieImage), findsOne);
    expect(find.byIcon(Icons.star), findsOne);
    expect(find.text("5.9"), findsOne);
    final image =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(image.imageUrl,
        "${dotenv.env["IMAGE_URL"]}/w780/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg");
  });
  testWidgets("test Movie Badge Widget", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NoteMovie(
            note: 6.912,
          ),
        ),
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('fr', ''), // English, no country code
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOne);
    expect(find.text("6.9"), findsOne);
  });
  testWidgets("test Movie Badge Widget with votes", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NoteMovie(
            note: 6.912,
            votes: 1234,
          ),
        ),
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('fr', ''), // English, no country code
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOne);
    expect(find.text("6.9"), findsOne);
    expect(find.textContaining("1234"), findsOne);
  });
}

const movieJson = {
  "poster_path": "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
  "adult": false,
  "overview":
      "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
  "release_date": "2016-08-03",
  "id": 297761,
  "original_title": "Suicide Squad",
  "original_language": "en",
  "title": "Suicide Squad",
  "backdrop_path": "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg",
  "popularity": 48.261451,
  "vote_count": 1466,
  "vote_average": 5.91
};
