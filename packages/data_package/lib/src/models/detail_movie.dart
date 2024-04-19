import 'package:data_package/src/models/genre.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_movie.g.dart';

@JsonSerializable()
class DetailMovie extends Equatable {
  final int revenue;
  final int? runtime;
  final String status;
  final String? tagline;
  @JsonKey(name: "original_language")
  final String? originalLanguage;

  final List<Genre> genres;

  factory DetailMovie.fromJson(Map<String, dynamic> json) =>
      _$DetailMovieFromJson(json);

  const DetailMovie(this.genres, this.revenue, this.runtime, this.status,
      this.tagline, this.originalLanguage);

  Map<String, dynamic> toJson() => _$DetailMovieToJson(this);

  @override
  List<Object?> get props => [
        revenue,
        runtime,
        status,
        originalLanguage,
        genres,
      ];
}
