import 'package:data_package/data_package.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_repository/src/common/local_storage_mixin.dart';
import 'package:movie_repository/src/common/network_mixin.dart';

Future<IResponse> computeParserMoviesJson(Map<String, dynamic> input) async {
  return MoviesResponse(
    maxPages: input["pages"],
    movies: (input["data"] as List).map((e) => Movie.fromJson(e)).toList(),
  );
}

abstract class MovieRepository extends Repository<Movie> {
  static MovieRepository? _instance;
  MovieRepository._();
  factory MovieRepository.init() {
    _instance ??= MovieRepositoryImpl._();
    return _instance!;
  }

  Future<IResponse> getDetail(int id);

  Future<IResponse> listMovieFavorites();

  Future<IResponse> searchForMovie(
    String query,
    int page, {
    String? region,
    String? year,
  });

  Future<bool> isMovieFav(int id);

  Future<int> addToFavorite(Movie movie);

  Future<int> removeFromFavorite(int movieId);
  Future<int> removeMoviesFromFavorite(List<int> movieIds);
}

class MovieRepositoryImpl extends MovieRepository
    with NetworkMixin, LocalStorageMixin {
  static const String prefixMovieURL = "movie";

  MovieRepositoryImpl._() : super._();

  @override
  Future<IResponse> getAll({String path = "", int page = 1}) async {
    final response = await get(
      endpoint: "$prefixMovieURL$path",
      query: {
        "page": page,
      },
    );
    if (response.statusCode != 200) {
      return ErrorResponse(error: "error to get movie");
    }
    final data = response.data as Map<String, dynamic>;
    return compute(
      computeParserMoviesJson,
      {
        "pages": data["total_pages"],
        "data": data["results"] as List<dynamic>,
      },
    );
  }

  @override
  Future<IResponse> getAllByFilter(filter) {
    // TODO: implement getAllByFilter
    throw UnimplementedError();
  }

  @override
  Future<IResponse> getDetail(int id) async {
    final response = await get(
      endpoint: "$prefixMovieURL/$id",
    );
    if (response.statusCode != 200) {
      return ErrorResponse(error: "error to get detail movie");
    }
    final data = response.data as Map<String, dynamic>;
    return Response<DetailMovie>(data: DetailMovie.fromJson(data));
  }

  @override
  Future<int> addToFavorite(Movie movie) async {
    try {
      await addFavorite(movie);
      return 200;
    } catch (e) {
      return 400;
    }
  }

  @override
  Future<int> removeFromFavorite(int movieId) async {
    try {
      await deleteFavorite(movieId);
      return 200;
    } catch (e) {
      return 400;
    }
  }

  @override
  Future<IResponse> listMovieFavorites() async {
    try {
      var list = await getFavorites();
      return MoviesResponse(maxPages: 1, movies: list);
    } catch (e) {
      return ErrorResponse(error: {"code": 404, "message": e.toString()});
    }
  }

  @override
  Future<bool> isMovieFav(int id) => isMovieFavorite(id);

  @override
  Future<IResponse> searchForMovie(
    String query,
    int page, {
    String? region,
    String? year,
  }) async {
    try {
      var queryEndPoint = {
        "query": query,
        "page": page,
      };
      if (region != null) {
        queryEndPoint.addAll({"region": region});
      }
      if (year != null) {
        queryEndPoint.addAll({"year": year});
      }
      var response = await get(endpoint: "search/movie", query: queryEndPoint);
      if (response.statusCode != 200) {
        return ErrorResponse(error: {
          "code": response.statusCode,
          "message": "cannot get data from server"
        });
      }
      final data = response.data as Map<String, dynamic>;
      return compute(
        computeParserMoviesJson,
        {
          "pages": data["total_pages"],
          "data": data["results"] as List<dynamic>,
        },
      );
    } catch (e) {
      return ErrorResponse(error: {"code": 404, "message": e.toString()});
    }
  }

  @override
  Future<int> removeMoviesFromFavorite(List<int> movieIds) async {
    try {
      await deleteFavorites(movieIds);
      return 200;
    } catch (e) {
      debugPrint(e.toString());
    }
    return 400;
  }
}
