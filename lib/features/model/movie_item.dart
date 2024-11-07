class MovieItem {
  String imageUrl;
  String title;
  String year;

  MovieItem(this.title, this.imageUrl,this.year);

  factory MovieItem.fromMap(Map map) {
    return MovieItem(map['original_title'] ?? '', map["poster_path"] ?? '',map['release_date']);
  }
}
