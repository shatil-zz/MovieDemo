import 'package:flutter/material.dart';
import 'package:movie_db_test/features/provider/movie_list_provider.dart';
import 'package:movie_db_test/features/widget/movie_list.dart';
import 'package:provider/provider.dart';

class MovieDBHome extends StatefulWidget {
  const MovieDBHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return MovieDbHomeState();
  }
}

class MovieDbHomeState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text("Search"),
          onTap: () {
            Provider.of<MovieListProvider>(context,listen: false).loadAllMovies();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MovieList(
              MovieType.topRated,
              key: Key(MovieType.topRated.name),
            ),
            MovieList(
              MovieType.nowPlaying,
              key: Key(MovieType.nowPlaying.name),
            ),
            MovieList(
              MovieType.upcoming,
              key: Key(MovieType.upcoming.name),
            ),
          ],
        ),
      ),
    );
  }
}
