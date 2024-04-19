import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class CheckMovieIsFavoriteUseCase extends FutureUseCase<int, bool> {
  final MovieRepository _repository;

  CheckMovieIsFavoriteUseCase(this._repository);

  @override
  Future<bool> invoke(int? parameter) async {
    return await _repository.isMovieFav(parameter!);
  }
}
