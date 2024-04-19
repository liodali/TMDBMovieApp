import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyAppLocalizations {

  MyAppLocalizations(this.locale);

  final Locale locale;

  static MyAppLocalizations? of(BuildContext context) {
    return Localizations.of<MyAppLocalizations>(context, MyAppLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title_app': 'Movie TMDB',
      'fav_movie_title': 'Favorite Movies ',
      'loading_text': 'Loading ...',
      'error_loading_image': 'Error to Get Image',
      'more_movies': 'more movies ...',
      'search_hint': 'search',
      'votes': 'votes',
      'success_add_fav': 'Added successfully to you favorite list',
      'success_remove_from_fav': 'This movie is  successfully removed From your favorite list',
      'success_remove_from_fav_mod': ' is  successfully removed From your favorite list',
      'failed_add_fav': 'Opp!Error to add this movie to your favorite list',
      'failed_remove_from_fav':
          'Opp!Error to remove this movie from your favorite list',
      'empty_list': 'No Movie Found',
      'empty_list_fav': 'You don\'t have any favorite movie'
    },
    'fr': {
      'title_app': 'Movie TMDB',
      'fav_movie_title': 'Favoris Films',
      'loading_text': 'Chargement ...',
      'error_loading_image': 'Impossible de télécharger cet image',
      'more_movies': 'plus de films ...',
      'search_hint': 'recherche',
      'votes': 'votes',
      'success_add_fav': 'ce film a été ajouté avec success',
      'success_remove_from_fav': 'ce film a été supprime de votre list favorie avec success',
      'success_remove_from_fav_mod': 'a été supprimée de votre list favorie avec success',
      'failed_add_fav':
          'Opps! nous ne pouvons pas ajouter votre film au favorite ',
      'failed_remove_from_fav':
          'Opps! nous ne pouvons pas supprime votre film de la liste favorite ',
      'empty_list': 'Aucun film est disponible',
      'empty_list_fav': 'Vous n\'avez aucun film favorie ',
    },
  };

  String get titleApp => _localizedValues[locale.languageCode]!['title_app']!;

  String get loadingText =>
      _localizedValues[locale.languageCode]!['loading_text']!;

  String get errorLoadImage =>
      _localizedValues[locale.languageCode]!['error_loading_image']!;

  String get moreMovies =>
      _localizedValues[locale.languageCode]!['more_movies']!;

  String get searchHint =>
      _localizedValues[locale.languageCode]!['search_hint']!;

  String get votes => _localizedValues[locale.languageCode]!['votes']!;

  String get successAddToFav =>
      _localizedValues[locale.languageCode]!['success_add_fav']!;

  String get successRemoveFromFav => _localizedValues[locale.languageCode]!['success_remove_from_fav']!;
  String get successRemoveFromFavMod => _localizedValues[locale.languageCode]!['success_remove_from_fav_mod']!;

  String get failedToAddToFav =>
      _localizedValues[locale.languageCode]!['failed_add_fav']!;

  String get failedToRemoveFromFav =>
      _localizedValues[locale.languageCode]!['failed_remove_from_fav']!;

  String get favMovieTitle =>
      _localizedValues[locale.languageCode]!['fav_movie_title']!;

  String get emptyList => _localizedValues[locale.languageCode]!['empty_list']!;
  String get emptyListFavorite => _localizedValues[locale.languageCode]!['empty_list_fav']!;
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<MyAppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<MyAppLocalizations> load(Locale locale) {
    return SynchronousFuture<MyAppLocalizations>(MyAppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
