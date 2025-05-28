import 'package:flutter/material.dart';
import 'package:responsi_prak_tpm/services/movie_service.dart';
import 'package:responsi_prak_tpm/model/movies.dart';
import 'package:responsi_prak_tpm/view/home.dart';

class EditMoviePage extends StatefulWidget {
  final int movieId;
  const EditMoviePage({Key? key, required this.movieId});

  @override
  State<EditMoviePage> createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  void _fetchMovie() async {
    try {
      final response = await UserApi.getMovieById(widget.movieId);
      final movie = Movies.fromJson(response["data"]);
      _titleController.text = movie.title ?? '';
      _yearController.text = movie.year?.toString() ?? '';
      _genreController.text = movie.genre ?? '';
      _directorController.text = movie.director ?? '';
      _ratingController.text = movie.rating?.toString() ?? '';
      _synopsisController.text = movie.synopsis ?? '';
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load movie: $e')));
    } finally {
      setState(() => _isFetching = false);
    }
  }

  void _submitEdit() async {
    setState(() => _isLoading = true);
    try {
      final movie = Movies(
        title: _titleController.text,
        year: int.tryParse(_yearController.text),
        genre: _genreController.text,
        director: _directorController.text,
        rating: double.tryParse(_ratingController.text),
        synopsis: _synopsisController.text,
      );
      final response = await UserApi.updateMovie(movie, widget.movieId);
      if (response["status"] == "Success") {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Movie updated successfully!")),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const Home()),
          );
        }
      } else {
        throw Exception(response["message"]);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      setState(() => _isLoading = false);
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
          'Update Movie',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _genreController,
                      decoration: const InputDecoration(labelText: 'Genre'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _directorController,
                      decoration: const InputDecoration(labelText: 'Director'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _ratingController,
                      decoration: const InputDecoration(labelText: 'Rating'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _synopsisController,
                      decoration: const InputDecoration(labelText: 'Synopsis'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[50],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Movie'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
