
import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class SearchForMoviesUseCase extends FutureUseCase<Map<String, dynamic>, IResponse> {
  final MovieRepository _repository;

  SearchForMoviesUseCase(this._repository);

  @override
  Future<IResponse> invoke(Map<String, dynamic>? parameter) async {
    return await _repository.searchForMovie(
          parameter!["query"],
          parameter["page"],
          region: parameter.containsKey("region") ? parameter["region"] : null,
          year: parameter.containsKey("year") ? parameter["year"] : null,
        );
  }
}
