import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';
class AddMovieToFavoriteUseCase extends FutureUseCase<Movie, int> {
  final MovieRepository _repository;

  AddMovieToFavoriteUseCase(this._repository);

  @override
  Future<int> invoke(Movie? parameter) async {
    return await _repository.addToFavorite(parameter!);
  }
}
