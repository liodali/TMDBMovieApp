
String calculateDurationMovie(int duration){
  int hour = duration~/60;
  int minutes = duration%60;
  return "${hour}h ${minutes}m";
}