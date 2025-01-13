import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equifax_tmdb/src/model/movie.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<Movie> _wishList = [];

  @override
  void initState() {
    super.initState();
    _loadWatchList();
  }

  Future<void> _loadWatchList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> watchListJson = prefs.getStringList('wishList') ?? [];
    final List<Movie> loadedWatchList = watchListJson
        .map((movieJson) => Movie.fromMap(jsonDecode(movieJson)))
        .toList();

    setState(() {
      _wishList = loadedWatchList;
    });
  }

  Future<void> _removeFromWishList(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final movieJson = jsonEncode(movie.toMap());
    final List<String> watchListJson = prefs.getStringList('wishList') ?? [];

    watchListJson.remove(movieJson);
    await prefs.setStringList('wishList', watchListJson);

    setState(() {
      _wishList.remove(movie);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${movie.title} fue eliminada de la lista de deseos'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_wishList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'WishList',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Text(
            'No hay películas en tu lista.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watchlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _wishList.length,
          itemBuilder: (context, index) {
            final movie = _wishList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  // Imagen a la izquierda
                  SizedBox(
                    width: 90,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 12), // Espacio entre la imagen y los textos

                  // Contenedor para el título, subtítulo y el botón de eliminación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          movie.title!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'release date',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          movie.releaseDate!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'average rating',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${movie.voteAverage ?? 0}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(                    
                    children: [
                      IconButton(
                        icon: const Icon(Icons.list, color: Colors.green),
                        onPressed: () {
                          _removeFromWishList(movie);
                        },
                      ),
                      SizedBox(height: 40,),
                      Text('Read More', style: TextStyle(color: Colors.green),)
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                print("Load More presionado");
              },
              child: const Text("Load More"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
