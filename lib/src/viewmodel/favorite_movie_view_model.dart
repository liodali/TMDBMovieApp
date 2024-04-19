import 'package:data_package/data_package.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/viewmodel/commons.dart';

final favoriteMoviesToDelete = StateProvider<List<int>>((ref) => []);
final canDeleteMovies = StateProvider<bool>((ref) => false);

final favoriteMoviesProvider =
    AutoDisposeNotifierProvider<FavoriteMoviesViewModel, IState>(
        FavoriteMoviesViewModel.new);

class FavoriteMoviesViewModel extends AutoDisposeNotifier<IState> {
  late final getMoviesFromFavoriteUseCase =
      ref.read(getMoviesFromFavoriteUseCaseProvider);
  late final removeMovieFromFavoriteUseCase =
      ref.read(removeMovieFromFavoriteUseCaseProvider);
  late final removeMoviesFromFav =
      ref.read(removeMoviesFromFavoriteUseCaseProvider);
  late final checkMovieIsFavoriteUseCase =
      ref.read(checkMovieIsFavoriteUseCaseProvider);

  Future<void> getMovieFavoriteList() async {
    state = const LoadingState();
    final moviesFav = await getMoviesFromFavoriteUseCase.invoke();
    switch (moviesFav) {
      case ErrorResponse():
        state = ErrorState(error: moviesFav.error.toString());
      case Response():
        state = MovieState(data: (moviesFav as MoviesResponse).data);
    }
  }

  Future<int> removeMovieFromFavoriteList(int movieId) =>
      removeMovieFromFavoriteUseCase.invoke(movieId);

  Future<int> removeMoviesFromFavorite(List<int> movieIds) =>
      removeMoviesFromFav.invoke(movieIds);

  Future<bool> checkMovieInFavorite(int movieId) =>
      checkMovieIsFavoriteUseCase.invoke(movieId);

  @override
  IState build() {
    state = const LoadingState();

    return state;
  }
}
