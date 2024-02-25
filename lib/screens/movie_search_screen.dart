import 'package:flutter/material.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  TextEditingController movieC = TextEditingController();

  @override
  void dispose() {
    movieC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Open Movie Database API',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: movieC,
              decoration: const InputDecoration(
                label: Text('Search'),
                hintText: 'Type a movie name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      movieC.clear();
                    },
                    child: const Text('Clear')),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () {
                      String movieName = movieC.text.trim();

                      if (movieName.isEmpty) {
                        SnackBar snackBar = const SnackBar(
                            content: Text(
                          'Please provide a movie name',
                        ));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        return;
                      }
                    },
                    child: const Text('Search')),
              ],
            ),
            // TODO: will display movie details here.
          ],
        ),
      ),
    );
  }
}
