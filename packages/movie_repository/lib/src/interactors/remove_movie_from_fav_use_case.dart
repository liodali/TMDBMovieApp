import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class RemoveMovieFromFavoriteUseCase extends FutureUseCase<int, int> {
  final MovieRepository _repository;

  RemoveMovieFromFavoriteUseCase(this._repository);

  @override
  Future<int> invoke(int? parameter) =>
      _repository.removeFromFavorite(parameter!);
}

class RemoveMoviesFromFavoriteUseCase extends FutureUseCase<List<int>, int> {
  final MovieRepository _repository;

  RemoveMoviesFromFavoriteUseCase(this._repository);

  @override
  Future<int> invoke(List<int>? parameter) =>
      _repository.removeMoviesFromFavorite(parameter!);
}
