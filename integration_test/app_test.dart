import 'dart:io';

import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/src/ui/component/item_movie.dart';
import 'package:movie_app/src/ui/component/list_movies.dart';
import 'package:movie_app/src/ui/pages/movie_detail.dart';
import 'package:movie_app/src/ui/widget/loading_widget.dart';
import 'package:movie_app/src/viewmodel/commons.dart';
import 'package:movie_repository/movie_repository.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MovieRepository repo;
  late DioAdapter dioAdapter;
  late ProviderContainer container;
  setUpAll(() async {
    await dotenv.load(fileName: ".env.test");
    final temp = await Directory.systemTemp.createTemp();
    Hive.init(temp.path);
    await HiveDB.init("FavoriteMovie");
    repo = MovieRepository.init();
    dioAdapter = DioAdapter(dio: (repo as MovieRepositoryImpl).dio);
    dioAdapter.onGet(
      "https://api.tmdb.org/3/movie/top_rated",
      (server) => server.reply(
        200,
        _pageAllTopRated,
        delay: const Duration(seconds: 2),
      ),
      queryParameters: {
        "page": 1,
        "api_key": "1234",
      },
    );
    dioAdapter.onGet(
      "https://api.tmdb.org/3/movie/${CategoryMovies.nowPlaying.typeMovieName}",
      (server) => server.reply(
        200,
        _pageAllTopRated,
        delay: const Duration(seconds: 2),
      ),
      queryParameters: {
        "page": 1,
        "api_key": "1234",
      },
    );
    dioAdapter.onGet(
      "https://api.tmdb.org/3/movie/693134",
      (server) => server.reply(
        200,
        detaiMovie,
        delay: const Duration(seconds: 1),
      ),
      queryParameters: {
        "api_key": "1234",
      },
    );
    container = ProviderContainer(
      overrides: [
        movieRepositoryProvider.overrideWithValue(repo),
        moviesListUseCaseProvider.overrideWithValue(
          MoviesListUseCase(repo),
        ),
      ],
    );
  });
  testWidgets("test app simple case", (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(LoadingWidget), findsOne);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(BodyListMovies), findsOne);
    expect(find.byType(ItemMovie), findsExactly(3));
    await tester.pumpAndSettle();
  });
  testWidgets("test app : switch to another category", (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(Tab), findsExactly(4));
    expect(find.byType(BodyListMovies), findsOne);
    expect(find.byType(ItemMovie), findsExactly(3));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining(CategoryMovies.nowPlaying.name));
    await tester.pump();
    expect(find.byType(LoadingWidget), findsOne);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(ItemMovie), findsExactly(3));
  });
  testWidgets("test app : switch to return back to previous category",
      (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(BodyListMovies), findsOne);
    expect(find.byType(ItemMovie), findsExactly(3));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining(CategoryMovies.topRated.name));
    await tester.pump();
    expect(find.byType(ItemMovie), findsExactly(3));
    await tester.tap(find.byType(ItemMovie).first);
    await tester.pumpAndSettle();
    expect(find.byType(MovieDetail), findsOne);
    expect(find.text("Science Fiction"), findsNothing);
    expect(find.textContaining("2686"), findsOne);
    expect(find.text("Dune: Part Two"), findsOne);
    expect(find.textContaining("Follow the mythic journey of Paul Atreides"),
        findsOne);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text("Science Fiction"), findsOne);
    await tester.pump();
  });
  tearDownAll(() => Hive.deleteFromDisk());
}

const _pageAllTopRated = <String, dynamic>{
  "page": 1,
  "total_pages": 206,
  "total_results": 4109,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg",
      "genre_ids": [878, 12],
      "id": 693134,
      "original_language": "en",
      "original_title": "Dune: Part Two",
      "overview":
          "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe, Paul endeavors to prevent a terrible future only he can foresee.",
      "popularity": 4651.845,
      "poster_path": "/5aUVLiqcW0kFTBfGsCWjvLas91w.jpg",
      "release_date": "2024-02-27",
      "title": "Dune: Part Two",
      "video": false,
      "vote_average": 8.3,
      "vote_count": 2686
    },
    {
      "adult": false,
      "backdrop_path": "/1XDDXPXGiI8id7MrUxK36ke7gkX.jpg",
      "genre_ids": [16, 28, 12, 35, 10751],
      "id": 1011985,
      "original_language": "en",
      "original_title": "Kung Fu Panda 4",
      "overview":
          "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.",
      "popularity": 3348.959,
      "poster_path": "/f7QBvIzoWSJw3jWPGnZBc5vwQ0l.jpg",
      "release_date": "2024-03-02",
      "title": "Kung Fu Panda 4",
      "video": false,
      "vote_average": 7.053,
      "vote_count": 864
    },
    {
      "adult": false,
      "backdrop_path": "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
      "genre_ids": [18, 80],
      "id": 278,
      "original_language": "en",
      "original_title": "The Shawshank Redemption",
      "overview":
          "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
      "popularity": 122.236,
      "poster_path": "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
      "release_date": "1994-09-23",
      "title": "The Shawshank Redemption",
      "video": false,
      "vote_average": 8.704,
      "vote_count": 26011
    },
  ],
};
const detaiMovie = <String, dynamic>{
  "adult": false,
  "backdrop_path": "/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg",
  "belongs_to_collection": {
    "id": 726871,
    "name": "Dune Collection",
    "poster_path": "/wcVafar6Efk3YgFvh8oZQ4yHL6H.jpg",
    "backdrop_path": "/ygVSGv86R0BTOKJIb8RQ1sFxs4q.jpg"
  },
  "budget": 190000000,
  "genres": [
    {"id": 878, "name": "Science Fiction"},
    {"id": 12, "name": "Adventure"}
  ],
  "homepage": "https://www.dunemovie.com",
  "id": 693134,
  "imdb_id": "tt15239678",
  "origin_country": ["US"],
  "original_language": "en",
  "original_title": "Dune: Part Two",
  "overview":
      "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe, Paul endeavors to prevent a terrible future only he can foresee.",
  "popularity": 2938.734,
  "poster_path": "/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg",
  "production_companies": [
    {
      "id": 923,
      "logo_path": "/8M99Dkt23MjQMTTWukq4m5XsEuo.png",
      "name": "Legendary Pictures",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {"iso_3166_1": "US", "name": "United States of America"}
  ],
  "release_date": "2024-02-27",
  "revenue": 683813734,
  "runtime": 167,
  "spoken_languages": [
    {"english_name": "English", "iso_639_1": "en", "name": "English"}
  ],
  "status": "Released",
  "tagline": "Long live the fighters.",
  "title": "Dune: Part Two",
  "video": false,
  "vote_average": 8.301,
  "vote_count": 2988
};
const movieJson = <String, dynamic>{
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
