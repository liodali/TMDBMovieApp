import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/viewmodel/commons.dart';
import 'package:movie_repository/movie_repository.dart';

final selectedMovieProvider = StateProvider<Movie?>((ref) => null);

final detailMovieProvider =
    NotifierProvider.autoDispose<DetailMovieViewModel, IState<DetailMovie>>(
        DetailMovieViewModel.new,
        dependencies: [selectedMovieProvider]);

class DetailMovieViewModel extends AutoDisposeNotifier<IState<DetailMovie>> {
  late final DetailMovieUseCase detailMovieUseCase =
      ref.read(detailMovieUseCaseProvider);
  late final CheckMovieIsFavoriteUseCase checkMovieIsFavoriteUseCase =
      ref.read(checkMovieIsFavoriteUseCaseProvider);
  late final AddMovieToFavoriteUseCase addMovieToFavoriteUseCase =
      ref.read(addMovieToFavoriteUseCaseProvider);
  late final RemoveMovieFromFavoriteUseCase removeMovieFromFavoriteUseCase =
      ref.read(removeMovieFromFavoriteUseCaseProvider);

  late final Movie? _movie = ref.watch(selectedMovieProvider);
  DetailMovie? _detailMovie;

  Movie? get movie => _movie;

  bool get isFav =>
      state is DetailMovieState ? (state as DetailMovieState).isFavorit : false;

  DetailMovie? get detailMovie => _detailMovie;

  DetailMovieViewModel();

  void setIsFav(bool fav) {
    state = (state as DetailMovieState).copyWith(isFavorit: fav);
  }

  @visibleForTesting
  void setDetail(DetailMovie detailMovie) {
    _detailMovie = detailMovie;
    state = DetailMovieState(
      data: detailMovie,
    );
  }

  Future<void> getDetailMovie() async {
    final response = await detailMovieUseCase.invoke(_movie!.id);
    if (response is Response<DetailMovie>) {
      _detailMovie = response.data;
      if (_detailMovie == null) {
        state = const ErrorState(error: "Ops!error to retrieve details");
      } else {
        state = DetailMovieState(data: _detailMovie!);
      }
    } else {
      state = const ErrorState(error: "Ops!error to retrieve details");
    }
  }

  Future<void> checkIsFav() async {
    final isFav = await checkMovieIsFavoriteUseCase.invoke(movie!.id);
    if (state is DetailMovieState) {
      state = (state as DetailMovieState).copyWith(
        isFavorit: isFav,
      );
    }
  }

  Future<int> addToFavorite() async {
    return await addMovieToFavoriteUseCase.invoke(movie);
  }

  Future<int> removeFromFavorite() async {
    return await removeMovieFromFavoriteUseCase.invoke(movie!.id);
  }

  @override
  IState<DetailMovie> build() {
    state = const LoadingState();
    Future.microtask(() async {
      await getDetailMovie();
      await checkIsFav();
    });
    ref.onDispose(() {
      ref.invalidate(selectedMovieProvider);
    });
    return state;
  }
}
