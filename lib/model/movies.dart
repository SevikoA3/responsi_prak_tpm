class Movies {
  int? id;
  String? title;
  int? year;
  double? rating;
  String? imgUrl;
  String? genre;
  String? director;
  String? synopsis;
  String? movieUrl;

  Movies({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.imgUrl,
    this.genre,
    this.director,
    this.synopsis,
    this.movieUrl,
  });

  Movies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    rating = json['rating'];
    imgUrl = json['imgUrl'];
    genre = json['genre'];
    director = json['director'];
    synopsis = json['synopsis'];
    movieUrl = json['movieUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['year'] = this.year;
    data['rating'] = this.rating;
    data['imgUrl'] = this.imgUrl;
    data['genre'] = this.genre;
    data['director'] = this.director;
    data['synopsis'] = this.synopsis;
    data['movieUrl'] = this.movieUrl;
    return data;
  }
}
