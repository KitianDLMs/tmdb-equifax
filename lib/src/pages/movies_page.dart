import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:equifax_tmdb/src/model/movie.dart';
import 'package:equifax_tmdb/src/pages/movie_detail_page.dart';
import 'package:equifax_tmdb/src/pages/watch_list_page.dart';
import 'package:equifax_tmdb/src/providers/movie.provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedMovieId;
  double rating = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<APIProvider>(context).getPopular();
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(
                  child: Text(
                    'Movie DB App',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 0),
                  child: Text(
                    "Find your movies",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SafeArea(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            print("Botón de búsqueda presionado");
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "  Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                        child: const Text(
                          'Category name',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                const Text(
                  "  Popular Movies",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                FutureBuilder<List<Movie>>(
                  future: movieProvider,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final movies = snapshot.data!;
                    return Column(
                      children: movies.map((movie) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(
                                  movie: movie,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "https://image.tmdb.org/t/p/original/${movie.posterPath}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Title'),
                                      Text(
                                        movie.title!,
                                        style: const TextStyle(
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Release Date:",
                                        style: const TextStyle(
                                            ),
                                      ),
                                      Text(
                                        "${movie.releaseDate}",
                                        style: const TextStyle(
                                            ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Average rating:",
                                      ),
                                      Text(
                                        "${movie.voteAverage}",
                                        style: const TextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();

                                          final movieJson =
                                              jsonEncode(movie.toMap());

                                          List<String> wishList =
                                              prefs.getStringList('wishList') ??
                                                  [];

                                          if (wishList.contains(movieJson)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${movie.title} ya está en la lista de vistos'),
                                              ),
                                            );
                                          } else {
                                            wishList.add(movieJson);
                                            await prefs.setStringList(
                                                'wishList', wishList);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${movie.title} añadida a la lista de vistos'),
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.list)),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedMovieId =
                                              selectedMovieId == movie.id
                                                  ? null
                                                  : movie.id;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 40,
                                      ),
                                    ),
                                    if (selectedMovieId == movie.id)
                                      Column(
                                        children: [
                                          Slider(
                                            value: rating,
                                            min: 1,
                                            max: 10,
                                            divisions: 9,
                                            label: rating.toStringAsFixed(1),
                                            onChanged: (value) {
                                              setState(() {
                                                rating = value;
                                              });
                                            },
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              print(
                                                  "Rating de ${movie.title}: $rating");
                                              setState(() {
                                                movie.userRating =
                                                    rating;
                                                selectedMovieId =
                                                    null;
                                              });
                                            },
                                            child: const Text("Submit"),
                                          ),
                                        ],
                                      ),
                                    if (movie.userRating != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text(
                                          "${movie.userRating != 0.0 ? movie.userRating!.toStringAsFixed(1) : 'na'}",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WishList(),
                  ),
                );
              },
              child: const Text("Watch List"),
            ),
          ],
        ),
      ),
    );
  }
}
