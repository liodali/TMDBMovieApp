import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class MoviesListUseCase extends FutureUseCase<Map<String, dynamic>, IResponse> {
  final MovieRepository _repository;

  MoviesListUseCase(this._repository);

  @override
  Future<IResponse> invoke(Map<String, dynamic>? parameter) =>
      _repository.getAll(
        path: parameter!["path"],
        page: parameter["page"],
      );
}
