import 'package:flutter/material.dart';
import 'package:responsi_prak_tpm/services/movie_service.dart';
import 'package:responsi_prak_tpm/model/movies.dart';
import 'package:responsi_prak_tpm/view/edit_movie_page.dart';
import 'package:responsi_prak_tpm/view/movie_detail_page.dart';
import 'package:responsi_prak_tpm/view/new_movie_page.dart';
import 'package:responsi_prak_tpm/util/local_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await LocalStorage.getUsername();
    setState(() {
      username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text(
          'Halo, ${username ?? "-"}',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _movieContainer(),
      ),
    );
  }

  Widget _movieContainer() {
    return FutureBuilder(
      future: UserApi.getMovies(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: \\${snapshot.error.toString()}");
        } else if (snapshot.hasData) {
          final data = snapshot.data as Map<String, dynamic>;
          final List movieList = data['data'] ?? [];
          List<Movies> movies = movieList
              .map((json) => Movies.fromJson(json))
              .toList();
          return _movieList(context, movies);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _movieList(BuildContext context, List<Movies> movies) {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewMoviePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[50],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: const Text('Add Movie'),
        ),
        for (var movie in movies)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movieId: movie.id!),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.imgUrl ?? '',
                        width: 70,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            movie.year?.toString() ?? '-',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating?.toString() ?? '-',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditMoviePage(movieId: movie.id!),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {}); // Refresh after edit
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[50],
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  _deleteMovie(movie.id!);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[50],
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _deleteMovie(int id) async {
    try {
      final response = await UserApi.deleteMovie(id);
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Movie Deleted")));
        setState(() {});
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
