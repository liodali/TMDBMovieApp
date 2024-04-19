import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/ui/pages/movie_detail.dart';

class AppRouter {
  static const String detailMovieNamePage = "detail-movie";
  static const String favoriteMoviesNamePage = "favorite";
  static const String homePage = "";

  static Route<dynamic>? routes(RouteSettings setting) {
    var arguments = setting.arguments;
    switch (setting.name) {
      case detailMovieNamePage:
        return MaterialPageRoute(
          builder: (ctx) {
            return MovieDetail(movie: arguments as Movie);
          },
        );
    }
    return null;
  }
}

extension MyAppRouter on BuildContext {
  Future<T?> navigate<T>(
    String path, {
    dynamic arguments,
  }) async {
    return Navigator.pushNamed<T>(this, path, arguments: arguments);
  }

  Future<T?> navigateAndPop<T, R>(
    String path, {
    dynamic arguments,
    R? result,
  }) async {
    return Navigator.popAndPushNamed<T, R?>(this, path,
        arguments: arguments, result: result);
  }

  Future<void> pop<T>({T? result}) async {
    return Navigator.pop<T?>(this, result);
  }
}
