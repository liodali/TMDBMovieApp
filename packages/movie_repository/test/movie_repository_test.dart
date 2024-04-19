import 'package:data_package/data_package.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:movie_repository/movie_repository.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

void main() async {
  await dotenv.load(fileName: ".env_test");
  Hive.init("./.dart_tool");
  await HiveDB.init("testDb");
  final repo = MovieRepository.init();
  final dioAdapter = DioAdapter(dio: (repo as MovieRepositoryImpl).dio);
  test('test movie repository getAll', () async {
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
    final moviesResponse = await repo.getAll();
    expect(moviesResponse.runtimeType, MoviesResponse);
    expect((moviesResponse as MoviesResponse).maxPages, 206);
    expect(moviesResponse.data.length, 2);
  });
  test('test movie repository get detail', () async {
    final dMovie = DetailMovie.fromJson(detailMovie);
    dioAdapter.onGet(
      "https://api.tmdb.org/3/movie/693134",
      (server) {
        server.reply(200, detailMovie);
      },
      queryParameters: {
        "api_key": "1234",
      },
    );
    final movieResponse = await repo.getDetail(693134);
    expect(movieResponse.runtimeType, Response<DetailMovie>);
    expect((movieResponse as Response<DetailMovie>).data, dMovie);
    expect((movieResponse.data).status, "Released");
  });
  test('test movie repository add fav', () async {
    final movie = Movie.fromJson(const {
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
    });
    var favMovie = await repo.getFavoriteById(693134);
    expect(favMovie, null);
    final result = await repo.addToFavorite(movie);
    expect(result, 200);
    favMovie = await repo.getFavoriteById(693134);
    expect(favMovie != null, true);
    expect(favMovie, movie);
  });
  test('test movie repository check is fav', () async {
    var isFav = await repo.isMovieFav(1011985);
    expect(isFav, false);
  });
  test('test movie repository remove fav', () async {
    var isFav = await repo.isMovieFav(693134);
    expect(isFav, true);
    final result = await repo.removeFromFavorite(693134);
    isFav = await repo.isMovieFav(693134);
    expect(result, 200);
    expect(isFav, false);
  });
  tearDownAll(() => Hive.deleteFromDisk());
}

const _pageAllTopRated = {
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
const detailMovie = {
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
  "original_language": "en",
  "original_title": "Dune: Part Two",
  "overview":
      "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe, Paul endeavors to prevent a terrible future only he can foresee.",
  "popularity": 4651.845,
  "poster_path": "/5aUVLiqcW0kFTBfGsCWjvLas91w.jpg",
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
  "revenue": 666813734,
  "runtime": 167,
  "spoken_languages": [
    {"english_name": "English", "iso_639_1": "en", "name": "English"}
  ],
  "status": "Released",
  "tagline": "Long live the fighters.",
  "title": "Dune: Part Two",
  "video": false,
  "vote_average": 8.3,
  "vote_count": 2692,
};
