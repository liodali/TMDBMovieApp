enum CategoryMovies {
  topRated("Top Rated", "top_rated"),
  popular("Popular", "popular"),
  nowPlaying("Now Playing", "now_playing"),
  upComing("UpComing", "upcoming");

  const CategoryMovies(this.name, this.typeMovieName);
  final String name;
  final String typeMovieName;
}
