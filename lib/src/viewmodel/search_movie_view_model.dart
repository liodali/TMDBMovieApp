import 'package:data_package/data_package.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/model/movie_list_state.dart';
import 'package:movie_app/src/viewmodel/commons.dart';

import 'package:movie_repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

final searchMovieProvier = AutoDisposeNotifierProvider<SearchMovieViewModel,
    IState<StreamListState<Movie, String>>>(SearchMovieViewModel.new);

class SearchMovieViewModel
    extends AutoDisposeNotifier<IState<StreamListState<Movie, String>>> {
  late final SearchForMoviesUseCase searchForMoviesUseCase =
      ref.read(searchForMoviesUseCaseProvider);
  SearchMovieViewModel();

  bool _isChanged = false;

  String get query => _query;

  final _moviesCache = <Movie>[];
  int maxPage = -1;
  int page = 1;

  String _query = "";

  final _moviesPublisher = PublishSubject<List<Movie>>();

  Stream<List<Movie>> get stream => _moviesPublisher.stream;

  bool get isQueryEmpty => _query.isEmpty;

  void setQuery(query) {
    if (_query != query) {
      _query = query;
      _isChanged = true;
    }
  }

  void update() {
    // _query = query;
    if (_isChanged && _query.isNotEmpty) {
      _moviesCache.clear();
      page = 1;
      maxPage = -1;
      _isChanged = false;
      searchForMovie();
    } else if (_query.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        _moviesPublisher.sink.add(_moviesCache);
      });
    }
  }

  void searchForMovie() async {
    final queryEndPoint = {
      "query": _query,
      "page": page,
    };

    final response = await searchForMoviesUseCase.invoke(queryEndPoint);
    if (response is ErrorResponse) {
      _moviesPublisher.sink.addError((response).error);
    } else {
      _moviesCache.addAll((response as MoviesResponse).data);
      _moviesPublisher.sink.add(_moviesCache);
    }
  }

  void clear() {
    _moviesCache.clear();
    page = 1;
    maxPage = -1;
    _isChanged = false;
  }

  @override
  IState<StreamListState<Movie, String>> build() {
    state = const LoadingState();
    ref.keepAlive();
    ref.onDispose(() {
      clear();
    });
    return state;
  }
}
