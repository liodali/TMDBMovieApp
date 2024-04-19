
import 'package:data_package/src/models/detail_movie.dart';
import 'package:data_package/src/models/genre.dart';
import 'package:data_package/src/models/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test fromJson Movie", () {
    final movie = Movie.fromJson(const {
      "poster_path": "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
      "adult": false,
      "overview":
          "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
      "release_date": "2016-08-03",
      "id": 297761,
      "original_title": "Suicide Squad",
      "original_language": "en",
      "title": "Suicide Squad",
      "backdrop_path": "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg",
      "popularity": 48.261451,
      "vote_count": 1466,
      "vote_average": 5.91
    });
    expect(movie.id, 297761);
    expect(movie.title, "Suicide Squad");
    expect(movie.vote, 5.91);
  });
  test("test fromJson DetailMovie", () {
    final genres = [
      {"id": 28, "name": "Action"},
      {"id": 12, "name": "Adventure"},
      {"id": 14, "name": "Fantasy"}
    ].map((e) => Genre.fromJson(e)).toList();
    final detailMovie = DetailMovie.fromJson(detailMovieJson);
    expect(detailMovie.status, "Released");
    expect(detailMovie.genres, genres);
    expect(detailMovie.revenue, 746846894);
  });
}

const detailMovieJson = {
  "adult": false,
  "backdrop_path": "/zC70x9wqPPtxU99HsoGsxQ8IhSw.jpg",
  "belongs_to_collection": {
    "id": 531242,
    "name": "Suicide Squad Collection",
    "poster_path": "/bdgaCpdDh0J0H7ZRpDP2NJ8zxJE.jpg",
    "backdrop_path": "/e0uUxFdhdGLcvy9eC7WlO2eLusr.jpg"
  },
  "budget": 175000000,
  "genres": [
    {"id": 28, "name": "Action"},
    {"id": 12, "name": "Adventure"},
    {"id": 14, "name": "Fantasy"}
  ],
  "homepage": "http://www.suicidesquad.com/",
  "id": 297761,
  "imdb_id": "tt1386697",
  "original_language": "en",
  "original_title": "Suicide Squad",
  "overview":
      "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
  "popularity": 62.383,
  "poster_path": "/xFw9RXKZDvevAGocgBK0zteto4U.jpg",
  "production_companies": [
    {
      "id": 174,
      "logo_path": "/zhD3hhtKB5qyv7ZeL4uLpNxgMVU.png",
      "name": "Warner Bros. Pictures",
      "origin_country": "US"
    },
    {
      "id": 41624,
      "logo_path": "/wzKxIeQKlMP0y5CaAw25MD6EQmf.png",
      "name": "RatPac Entertainment",
      "origin_country": "US"
    },
    {
      "id": 128064,
      "logo_path": "/13F3Jf7EFAcREU0xzZqJnVnyGXu.png",
      "name": "DC Films",
      "origin_country": "US"
    },
    {
      "id": 507,
      "logo_path": "/aRmHe6GWxYMRCQljF75rn2B9Gv8.png",
      "name": "Atlas Entertainment",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {"iso_3166_1": "US", "name": "United States of America"}
  ],
  "release_date": "2016-08-03",
  "revenue": 746846894,
  "runtime": 123,
  "spoken_languages": [
    {"english_name": "English", "iso_639_1": "en", "name": "English"},
    {"english_name": "Japanese", "iso_639_1": "ja", "name": "日本語"},
    {"english_name": "Spanish", "iso_639_1": "es", "name": "Español"}
  ],
  "status": "Released",
  "tagline": "Worst. Heroes. Ever.",
  "title": "Suicide Squad",
  "video": false,
  "vote_average": 5.911,
  "vote_count": 20577,
};
