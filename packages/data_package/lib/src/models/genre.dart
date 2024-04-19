import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()
class Genre extends Equatable {
  final int id;
  final String name;

  factory Genre.fromJson(Map<String, dynamic> json) =>
      _$GenreFromJson(json);


  Map<String, dynamic> toJson() => _$GenreToJson(this);

  const Genre(this.id, this.name,);
  
  @override
  List<Object?> get props => [id,name];
}