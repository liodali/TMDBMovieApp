import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/model/movie_list_state.dart';
import 'package:movie_app/src/viewmodel/commons.dart';
import 'package:movie_repository/movie_repository.dart';

typedef MovieState = IState<StreamListState<Movie, String>>;

final moviesProvider =
    NotifierProvider.family<MoviesViewModel, MovieState, CategoryMovies>(
        MoviesViewModel.new);

class MoviesViewModel extends FamilyNotifier<MovieState, CategoryMovies> {
  late final MoviesListUseCase moviesListUseCase =
      ref.read(moviesListUseCaseProvider);
  String _typeMovieSelected = CategoryMovies.topRated.typeMovieName;
  ScrollController scrollController = ScrollController();

  final _moviesCache = <Movie>[];

  bool get isLoading =>
      state is LoadingState ||
      (state is MovieListState && (state as MovieListState).isLoading);

  Future<void> _initMovies(CategoryMovies categoryMovies) => _fetchMovies(
        categoryMovies.typeMovieName,
        1,
      );

  Future<void> getMovies({bool restart = false}) async {
    var maxPage =
        state is MovieListState ? (state as MovieListState).maxPage : -1;
    var page = state is MovieListState ? (state as MovieListState).page : 1;
    if (restart) {
      page = 1;
      maxPage = -1;
      _moviesCache.clear();
      state = const LoadingState();
    }
    if ((page < maxPage && maxPage != -1) || !isLoading) {
      if (state is MovieListState) {
        state = (state as MovieListState).copyWith(isLoading: true);
      }
      _fetchMovies(_typeMovieSelected, page);
    }
  }

  Future<void> _fetchMovies(
    String path,
    int page,
  ) async {
    final result = await moviesListUseCase.invoke({
      "path": "/$path",
      "page": page,
    });
    if (result is MoviesResponse) {
      _moviesCache.addAll(result.data);
      final nextPage = page + 1;
      switch (state) {
        case MovieListState():
          state = (state as MovieListState).copyWith(
            movies: _moviesCache,
            maxPage: result.maxPages,
            page: nextPage,
            isLoading: false,
          );
        case LoadingState():
          state = MovieListState(
            movies: _moviesCache,
            page: nextPage,
            maxPage: result.maxPages,
          );
        default:
      }
    } else if (result is ErrorResponse && state is LoadingState) {
      state = ErrorState(error: result.error);
    } else if (result is ErrorResponse && state is MovieListState) {
      state = (state as MovieListState).copyWith(errorString: result.error);
    }
  }

  @override
  MovieState build(CategoryMovies arg) {
    _typeMovieSelected = arg.typeMovieName;
    state = const LoadingState();

    Future.microtask(() async {
      await _initMovies(arg);
    });
    return state;
  }
}
