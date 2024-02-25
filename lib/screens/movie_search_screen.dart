import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omdb_api_app/models/movie_blueprint.dart';
import 'package:omdb_api_app/utility/constants.dart';
import 'package:http/http.dart' as http;

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  TextEditingController movieC = TextEditingController();
  StreamController streamController = StreamController();
  Movie? movie;

  @override
  void initState() {
    streamController.add(Constants.Initial);
    super.initState();
  }

  @override
  void dispose() {
    movieC.dispose();
    super.dispose();
  }

  Future<Movie?> getMovieDetails(String movieName) async {
    String url = 'https://www.omdbapi.com/?t=$movieName&apikey=c4cc281e';

    streamController.add(Constants.Loading);

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['Response'] == 'True') {
        streamController.add(Constants.Found);

        movie = Movie.fromJson(jsonResponse);
      } else {
        streamController.add(Constants.NotFound);
      }
    } else {
      streamController.add(Constants.Error);
    }

    return movie;
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
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      movieC.clear();
                      streamController.add(Constants.Initial);
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
                      getMovieDetails(movieName);
                    },
                    child: const Text('Search')),
              ],
            ),
            StreamBuilder(
                stream: streamController.stream,
                builder: ((context, snapshot) {
                  // will handle all the events cases
                  return const SizedBox.shrink();
                })),
          ],
        ),
      ),
    );
  }
}
