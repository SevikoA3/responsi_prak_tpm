import 'dart:convert';
import 'package:responsi_prak_tpm/model/movies.dart';

// Supaya dapat mengirimkan HTTP request
import 'package:http/http.dart' as http;

class UserApi {
  static const url =
      "https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/movies";
  static Future<Map<String, dynamic>> getMovies() async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createMovie(Movies movie) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getMovieById(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateMovie(Movies movie, id) async {
    final response = await http.patch(
      Uri.parse("$url/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": movie.title,
        "year": movie.year,
        "genre": movie.genre,
        "director": movie.director,
        "rating": movie.rating,
        "synopsis": movie.synopsis,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }
}
