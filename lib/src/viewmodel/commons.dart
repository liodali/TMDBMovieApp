
import 'package:data_package/data_package.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_repository/movie_repository.dart';

//MovieRepository _repository
final movieRepositoryProvider = Provider((ref) {
  return MovieRepository.init();
});
final selectedCategoryProvider =
    StateProvider((ref) => CategoryMovies.topRated);

final moviesListUseCaseProvider = Provider(
  (ref) => MoviesListUseCase(
    ref.read(movieRepositoryProvider),
  ),
);
final addMovieToFavoriteUseCaseProvider = Provider(
  (ref) => AddMovieToFavoriteUseCase(
    ref.read(movieRepositoryProvider),
  ),
);
final checkMovieIsFavoriteUseCaseProvider = Provider(
  (ref) => CheckMovieIsFavoriteUseCase(
    ref.read(movieRepositoryProvider),
  ),
);
final detailMovieUseCaseProvider = Provider(
  (ref) => DetailMovieUseCase(
    ref.read(movieRepositoryProvider),
  ),
);

final getMoviesFromFavoriteUseCaseProvider = Provider(
  (ref) => GetMoviesFromFavoriteUseCase(
    ref.read(movieRepositoryProvider),
  ),
);

final removeMovieFromFavoriteUseCaseProvider = Provider(
  (ref) => RemoveMovieFromFavoriteUseCase(
    ref.read(movieRepositoryProvider),
  ),
);
final removeMoviesFromFavoriteUseCaseProvider = Provider(
  (ref) => RemoveMoviesFromFavoriteUseCase(
    ref.read(movieRepositoryProvider),
  ),
);
final searchForMoviesUseCaseProvider = Provider(
  (ref) => SearchForMoviesUseCase(
    ref.read(movieRepositoryProvider),
  ),
);
