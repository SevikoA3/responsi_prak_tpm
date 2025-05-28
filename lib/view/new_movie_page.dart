import 'package:flutter/material.dart';
import 'package:responsi_prak_tpm/services/movie_service.dart';
import 'package:responsi_prak_tpm/model/movies.dart';
import 'package:responsi_prak_tpm/view/home.dart';

class NewMoviePage extends StatefulWidget {
  const NewMoviePage({Key? key});

  @override
  State<NewMoviePage> createState() => _NewMoviePageState();
}

class _NewMoviePageState extends State<NewMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  bool _isLoading = false;

  void _submitMovie() async {
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
      final response = await UserApi.createMovie(movie);
      if (response["status"] == "Success") {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Movie added successfully!")),
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
          'Add New Movie',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year (1900-2025)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
              ),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: 'Director'),
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating (0-10)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _synopsisController,
                decoration: const InputDecoration(labelText: 'Synopsis'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitMovie,
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
                    : const Text('Submit New Movie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
