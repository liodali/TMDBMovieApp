import 'package:data_package/data_package.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/src/model/movie_list_state.dart';

sealed class IState<T> extends Equatable {
  final T? _data;

  const IState({required T? data}) : _data = data;
}

class MovieState extends IState<List<Movie>> {
  final bool isFavorit;
  const MovieState({
    required List<Movie> data,
    this.isFavorit = false,
  }) : super(data: data);
  List<Movie> get data => super._data!;

  @override
  List<Object?> get props => [data, isFavorit];
}

class MovieListState extends IState<StreamListState<Movie, String>> {
  final int page;
  final int maxPage;
  MovieListState({
    required List<Movie> movies,
    bool isLoading = false,
    String errorMsg = "",
    this.page = 1,
    this.maxPage = 0,
  }) : super(
          data: StreamListState(
            data: movies,
            errorMsg: errorMsg,
            isLoading: isLoading,
          ),
        );
  List<Movie> get movies => super._data!.data;
  bool get isLoading => super._data!.isLoading;
  MovieListState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? errorString,
    int? page = 0,
    int? maxPage = 0,
  }) =>
      MovieListState(
        page: page ?? this.page,
        maxPage: maxPage ?? this.maxPage,
        isLoading: isLoading ?? _data!.isLoading,
        movies: movies ?? _data!.data,
        errorMsg: errorString ?? _data!.errorMsg,
      );
  @override
  List<Object?> get props => [
        _data,
        page,
        isLoading,
        maxPage,
      ];
}

class DetailMovieState extends IState<DetailMovie> {
  final bool isFavorit;
  const DetailMovieState({
    required DetailMovie data,
    this.isFavorit = false,
  }) : super(data: data);
  DetailMovie get detailMovie => super._data!;

  DetailMovieState copyWith({
    DetailMovie? data,
    bool? isFavorit,
  }) =>
      DetailMovieState(
        data: data ?? detailMovie,
        isFavorit: isFavorit ?? this.isFavorit,
      );

  @override
  List<Object?> get props => [_data, isFavorit];
}

class LoadingState<T> extends IState<T> {
  const LoadingState() : super(data: null);

  @override
  List<Object?> get props => [];
}

class NoState<T> extends IState<T> {
  const NoState() : super(data: null);

  @override
  List<Object?> get props => [];
}

class ErrorState<T> extends IState<T> {
  final String error;

  const ErrorState({required this.error}) : super(data: null);
  @override
  List<Object?> get props => [error];
}
