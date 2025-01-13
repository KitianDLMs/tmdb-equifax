import 'package:equifax_tmdb/src/pages/movies_page.dart';
import 'package:equifax_tmdb/src/providers/movie.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() { runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => APIProvider())
    ],
    child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(      
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}