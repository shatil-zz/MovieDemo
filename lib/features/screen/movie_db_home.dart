import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:movie_db_test/features/provider/movie_list_provider.dart';
import 'package:movie_db_test/features/widget/movie_list.dart';
import 'package:movie_db_test/features/widget/movie_search.dart';
import 'package:provider/provider.dart';

class MovieDBHome extends StatefulWidget {
  const MovieDBHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return MovieDbHomeState();
  }
}

class MovieDbHomeState extends State<StatefulWidget> {
  final controller = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: SearchBar(
                controller: controller,
                trailing: [
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      controller.text = '';
                      Provider.of<MovieListProvider>(context, listen: false)
                          .searchAllMovies(controller.text);
                    },
                    child: const Icon(Icons.close),
                  )
                ],
                hintText: "Search",
                onChanged: (text) {
                  _debouncer.debounce(
                      duration: const Duration(seconds: 2),
                      onDebounce: () {
                        Provider.of<MovieListProvider>(context, listen: false)
                            .searchAllMovies(controller.text);
                      });
                },
              ),
            ),
            Consumer<MovieListProvider>(builder: (context, provider, child) {
              return controller.text.trim().isEmpty
                  ? Column(
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
                    )
                  : const MovieSearch(
                      key: Key("search"),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
