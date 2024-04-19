import 'dart:io';

import 'package:data_package/data_package.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/model/movie_list_state.dart';
import 'package:movie_app/src/viewmodel/commons.dart';
import 'package:movie_app/src/viewmodel/movies_view_model.dart';
import 'package:movie_repository/movie_repository.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MovieRepository repo;
  late DioAdapter dioAdapter;
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
      ),
      queryParameters: {
        "page": 1,
        "api_key": "1234",
      },
    );
  });
  test('test init state', () async {
    final container = ProviderContainer(overrides: [
      //movieRepositoryProvider.overrideWithValue(MovieRepository.init()),
      moviesListUseCaseProvider
          .overrideWithValue(MoviesListUseCase(MovieRepository.init()))
    ]);
    addTearDown(container.dispose);
    final listener = Listener<IState<StreamListState<Movie, String>>>();

    container.listen<IState<StreamListState<Movie, String>>>(
      moviesProvider(CategoryMovies.topRated),
      listener.call,
      fireImmediately: true,
    );

    final cstate = container.read(moviesProvider(CategoryMovies.topRated));
    expect(cstate, const LoadingState<StreamListState<Movie, String>>());
  });
  test('test wait the data', () async {
    final container = ProviderContainer(overrides: [
      //movieRepositoryProvider.overrideWithValue(MovieRepository.init()),
      moviesListUseCaseProvider
          .overrideWithValue(MoviesListUseCase(MovieRepository.init()))
    ]);
    addTearDown(container.dispose);
    final listener = Listener<IState<StreamListState<Movie, String>>>();

    container.listen<IState<StreamListState<Movie, String>>>(
      moviesProvider(CategoryMovies.topRated),
      listener.call,
      fireImmediately: true,
    );

    var cstate = container.read(moviesProvider(CategoryMovies.topRated));
    expect(cstate, const LoadingState<StreamListState<Movie, String>>());
    await Future.delayed(const Duration(seconds: 4));
    cstate = container.read(moviesProvider(CategoryMovies.topRated));
    expect(
        cstate,
        MovieListState(
          movies: (List.from(_pageAllTopRated["results"]))
              .map((e) => Movie.fromJson(e))
              .toList(),
              maxPage: 206,
              page: 2
        ));
  });
}

const _pageAllTopRated = <String,dynamic>{
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
    },
  ],
};
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
