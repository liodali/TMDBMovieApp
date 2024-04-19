import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveDB {
  static Box? _box;

  static Future<void> init(String boxName) async {
    _box = await Hive.openBox(boxName);
    if (_box!.containsKey("FavoriteMoviesIds")) {
      _box!.delete("FavoriteMoviesIds");
    }
  }

  static Box get db => _box!;
}

mixin LocalStorageMixin {
  final dbFavoriteHive = HiveDB.db;

  @visibleForTesting
  Future<void> clearAll() async {
    await dbFavoriteHive.clear();
    await dbFavoriteHive.deleteFromDisk();
  }

  Future<bool> isMovieFavorite(int id) async {
    return dbFavoriteHive.containsKey(id);
  }

  Future<void> addFavorite(Movie movie) async {
    if (!dbFavoriteHive.containsKey(movie.id)) {
      await dbFavoriteHive.put(movie.id, movie.toJson());
    }
  }

  Future<void> deleteFavorite(int movieId) async {
    if (dbFavoriteHive.containsKey(movieId)) {
      await dbFavoriteHive.delete(movieId);
    }
  }
  Future<void> deleteFavorites(List<int> movieIds) 
      => dbFavoriteHive.deleteAll(movieIds);
    
  

  Future<Movie?> getFavoriteById(int id) async {
    if (dbFavoriteHive.containsKey(id)) {
      final data = await dbFavoriteHive.get(id);
      Map<String, dynamic> map = data.cast<String, dynamic>()
          as Map<String, dynamic>; //Map<String, dynamic>.from(data);
      return Movie.fromJson(map);
    }
    return null;
  }

  Future<List<Movie>> getFavorites() async {
    List<int> ids = List<int>.from(dbFavoriteHive.keys.toList());
    List<Movie> movies = [];
    for (int id in ids) {
      final m = await getFavoriteById(id);
      movies.add(m!);
    }
    return movies;
  }
}
