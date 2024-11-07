import 'package:flutter/material.dart';
import 'package:movie_db_test/features/model/movie_item.dart';
import 'package:movie_db_test/features/model/movie_list_model.dart';
import 'package:movie_db_test/features/provider/movie_list_provider.dart';
import 'package:provider/provider.dart';

enum MovieType { topRated, nowPlaying, upcoming }

class MovieList extends StatefulWidget {
  final MovieType type;

  const MovieList(this.type, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MovieListSate();
  }
}

class MovieListSate extends State<MovieList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - 40,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTitle(widget.type),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<MovieListProvider>(
                builder: (context, provider, child) {
                  final listModel = getSelectedModel(widget.type, provider);
                  if (listModel.list.isEmpty) {
                    if (listModel.isLoading) {
                      return const SizedBox(
                        height: 230,
                        child: Center(
                          heightFactor: .5,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (listModel.error != null) {
                      return SizedBox(
                        height: 230,
                        child: Center(
                            child: Text(
                          listModel.error!,
                          style: const TextStyle(color: Colors.red),
                        )),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                  return getListView(listModel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListView(MovieListModel listModel) {
    return Container(
      width: MediaQuery.sizeOf(context).width - 60,
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index >= listModel.list.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          MovieItem item = listModel.list[index];
          return SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w185${item.imageUrl}',
                  height: 160,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Text(item.year.split("-")[0],
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ),
              ],
            ),
          );
        },
        itemCount: listModel.list.length + (listModel.isLoading ? 1 : 0),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      Provider.of<MovieListProvider>(context, listen: false)
          .fetchMovies(widget.type);
    }
  }

  MovieListModel getSelectedModel(MovieType type, MovieListProvider provider) {
    switch (type) {
      case MovieType.topRated:
        return provider.topRatedMovies;
      case MovieType.nowPlaying:
        return provider.nowPlayingMovies;
      case MovieType.upcoming:
        return provider.upcomingMovies;
    }
  }

  String getTitle(MovieType type) {
    switch (type) {
      case MovieType.topRated:
        return "Top Rated";
      case MovieType.nowPlaying:
        return "Now Playing";
      case MovieType.upcoming:
        return "Upcoming";
    }
  }
}
