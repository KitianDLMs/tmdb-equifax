import 'dart:convert';

import 'package:equifax_tmdb/src/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = "d404b276fedd325041cdf745e3026d64";

class APIProvider with ChangeNotifier {
  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final nowShowingApi =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  final upCommingApi =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApi =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApi =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final reviews = "https://api.themoviedb.org/3/movie/{movie_id}/reviews";

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _popularMovies = await APIProvider().getPopular();
    } catch (e) {
      print("Error fetching movies: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getReviews(int movieId) async {
    final reviewsApi =
        "https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey";
    Uri url = Uri.parse(reviewsApi);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        print('provider $data');
        return data; // Devuelve las reseñas como una lista de mapas o dinámicos.
      } else {
        throw Exception("Failed to load reviews");
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      return [];
    }
  }  

  Future<List<Movie>> getPopular() async {
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<Movie>> getTopRated() async {
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }
}
