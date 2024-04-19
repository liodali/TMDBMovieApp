
import 'package:data_package/data_package.dart';
import 'package:movie_repository/src/repository/movie_repository_impl.dart';

class GetMoviesFromFavoriteUseCase extends FutureUseCase0<IResponse> {
  final MovieRepository _repository;

  GetMoviesFromFavoriteUseCase(this._repository);

  @override
  Future<IResponse> invoke() async{
   return _repository.listMovieFavorites();
  }


}
