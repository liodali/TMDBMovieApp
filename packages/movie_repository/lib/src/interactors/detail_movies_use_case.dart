
import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class DetailMovieUseCase extends FutureUseCase<int, IResponse> {
  final MovieRepository _repository;

  DetailMovieUseCase(this._repository);

  @override
  Future<IResponse> invoke(int? parameter) async {
    return await _repository.getDetail(parameter!);
  }
}
