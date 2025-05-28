import 'package:flutter/material.dart';
import 'package:responsi_prak_tpm/services/movie_service.dart';
import 'package:responsi_prak_tpm/model/movies.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  const MovieDetailPage({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<Movies> _movieFuture;

  @override
  void initState() {
    super.initState();
    _movieFuture = fetchMovie();
  }

  Future<Movies> fetchMovie() async {
    final response = await UserApi.getMovieById(widget.movieId);
    if (response['data'] != null) {
      return Movies.fromJson(response['data']);
    } else {
      throw Exception('Movie not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Movie Detail',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<Movies>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Movie not found'));
          }
          final movie = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.imgUrl ?? '',
                        width: 120,
                        height: 170,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 170,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama: \\${movie.title ?? '-'}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          if (movie.director != null)
                            Text(
                              'Director: \\${movie.director}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          if (movie.genre != null)
                            Text(
                              'Genre: \\${movie.genre}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          Text(
                            'Year: \\${movie.year?.toString() ?? '-'}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Rating: \\${movie.rating?.toString() ?? '-'} / 5.0',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Synopsis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.synopsis ?? '-',
                  style: const TextStyle(fontSize: 14),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (movie.movieUrl != null &&
                          await canLaunchUrl(Uri.parse(movie.movieUrl!))) {
                        await launchUrl(Uri.parse(movie.movieUrl!));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text('Movie Website'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
