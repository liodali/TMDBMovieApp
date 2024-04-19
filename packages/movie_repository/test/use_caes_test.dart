import 'package:data_package/data_package.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_repository/movie_repository.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

void main() {
  late final DioAdapter dioAdapter;
  late final MovieRepository repo;
  setUpAll(() async {
    await dotenv.load(fileName: ".env_test");
    Hive.init("./.dart_tool");
    await HiveDB.init("testDb");
    repo = MovieRepository.init();
    dioAdapter = DioAdapter(dio: (repo as MovieRepositoryImpl).dio);
  });
  test("test use case get movies", () async {
    final moviesUseCase = MoviesListUseCase(repo);
    final response = MoviesResponse(
      maxPages: 206,
      movies: List.from(_pageAllTopRated["result"])
          .map((e) => Movie.fromJson(e))
          .toList(),
    );
    dioAdapter.onGet(
      "https://api.tmdb.org/3/movie",
      (server) {
        server.reply(200, _pageAllTopRated);
      },
      queryParameters: {
        "page": 1,
        "api_key": "1234",
      },
    );
    final movies = await moviesUseCase.invoke({"page": 1});
    expect(movies.runtimeType, MoviesResponse);
    expect(movies, response);
  });
  test("test use case add/remove, check movie in favorite", () async {
    final movie = Movie.fromJson(movieJson);
    final addFavUseCase = AddMovieToFavoriteUseCase(repo);
    final deleteFavUseCase = RemoveMovieFromFavoriteUseCase(repo);
    final chechFavUseCase = CheckMovieIsFavoriteUseCase(repo);
    var isFav = await chechFavUseCase.invoke(movie.id);
    expect(isFav, false);
    final added = await addFavUseCase.invoke(movie);
    isFav = await chechFavUseCase.invoke(movie.id);
    expect(added, 200);
    expect(isFav, true);
    await deleteFavUseCase.invoke(movie.id);
    isFav = await chechFavUseCase.invoke(movie.id);
    expect(isFav, false);
  });
  tearDownAll(() => Hive.deleteFromDisk());
}

const movieJson = <String, dynamic>{
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
};
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
  ],
};
