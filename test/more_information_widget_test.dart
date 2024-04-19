import 'dart:io';

import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/utilities.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/ui/component/more_information_movie.dart';
import 'package:movie_app/src/viewmodel/detail_movie_view_model.dart';
import 'package:movie_repository/movie_repository.dart';

// Using mockito to keep track of when a provider notify its listeners
class Listener extends Mock {
  void call(IState<DetailMovie>? previous, IState<DetailMovie> value);
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final temp = await Directory.systemTemp.createTemp();
  Hive.init(temp.path);
  await HiveDB.init("FavoriteMovie");
  final movie = Movie.fromJson(movieJson);
  final container = ProviderContainer(
      overrides: [selectedMovieProvider.overrideWith((ref) => movie)]);
  final listenerDetailMovie = Listener();

  testWidgets("check more information", (tester) async {
    await tester.runAsync(() async {
      // Observe a provider and spy the changes.
      container.listen<IState<DetailMovie>>(
        detailMovieProvider,
        listenerDetailMovie.call,
        fireImmediately: true,
      );
      container.read(detailMovieProvider.notifier).setDetail(
            DetailMovie.fromJson(detailMovieJson),
          );
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: MoreInformationMovie(),
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
      ),
    );
    await tester.pump();
    await tester.runAsync(() async {});
    final duration = calculateDurationMovie(123);
    expect(find.text(duration), findsOneWidget);
    expect(find.text("EN"), findsOneWidget);
    expect(find.text("Action"), findsOneWidget);
    expect(find.text("Adventure"), findsOneWidget);
    expect(find.text("Fantasy"), findsOneWidget);
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
const detailMovieJson = {
  "adult": false,
  "backdrop_path": "/zC70x9wqPPtxU99HsoGsxQ8IhSw.jpg",
  "belongs_to_collection": {
    "id": 531242,
    "name": "Suicide Squad Collection",
    "poster_path": "/bdgaCpdDh0J0H7ZRpDP2NJ8zxJE.jpg",
    "backdrop_path": "/e0uUxFdhdGLcvy9eC7WlO2eLusr.jpg"
  },
  "budget": 175000000,
  "genres": [
    {"id": 28, "name": "Action"},
    {"id": 12, "name": "Adventure"},
    {"id": 14, "name": "Fantasy"}
  ],
  "homepage": "http://www.suicidesquad.com/",
  "id": 297761,
  "imdb_id": "tt1386697",
  "original_language": "en",
  "original_title": "Suicide Squad",
  "overview":
      "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
  "popularity": 62.383,
  "poster_path": "/xFw9RXKZDvevAGocgBK0zteto4U.jpg",
  "production_companies": [
    {
      "id": 174,
      "logo_path": "/zhD3hhtKB5qyv7ZeL4uLpNxgMVU.png",
      "name": "Warner Bros. Pictures",
      "origin_country": "US"
    },
    {
      "id": 41624,
      "logo_path": "/wzKxIeQKlMP0y5CaAw25MD6EQmf.png",
      "name": "RatPac Entertainment",
      "origin_country": "US"
    },
    {
      "id": 128064,
      "logo_path": "/13F3Jf7EFAcREU0xzZqJnVnyGXu.png",
      "name": "DC Films",
      "origin_country": "US"
    },
    {
      "id": 507,
      "logo_path": "/aRmHe6GWxYMRCQljF75rn2B9Gv8.png",
      "name": "Atlas Entertainment",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {"iso_3166_1": "US", "name": "United States of America"}
  ],
  "release_date": "2016-08-03",
  "revenue": 746846894,
  "runtime": 123,
  "spoken_languages": [
    {"english_name": "English", "iso_639_1": "en", "name": "English"},
    {"english_name": "Japanese", "iso_639_1": "ja", "name": "日本語"},
    {"english_name": "Spanish", "iso_639_1": "es", "name": "Español"}
  ],
  "status": "Released",
  "tagline": "Worst. Heroes. Ever.",
  "title": "Suicide Squad",
  "video": false,
  "vote_average": 5.911,
  "vote_count": 20577,
};
