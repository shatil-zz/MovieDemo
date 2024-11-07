import 'package:flutter/material.dart';
import 'package:movie_db_test/features/model/movie_item.dart';
import 'package:movie_db_test/features/model/movie_list_model.dart';
import 'package:movie_db_test/features/provider/movie_list_provider.dart';
import 'package:provider/provider.dart';

class MovieSearch extends StatefulWidget {
  const MovieSearch({super.key});

  @override
  State<StatefulWidget> createState() {
    return MovieListSate();
  }
}

class MovieListSate extends State<MovieSearch> {
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
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<MovieListProvider>(
                builder: (context, provider, child) {
                  final listModel = provider.searchMovies;
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
      height: MediaQuery.sizeOf(context).height - 100,
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
            height: 230,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w185${item.imageUrl}',
                  width: 150,
                  errorBuilder: (context,ob,st){
                    return const SizedBox(width: 150,child: Icon(Icons.error),);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  width: MediaQuery.sizeOf(context).width - 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Flexible(
                        child: Text(item.year.split("-")[0],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        itemCount: listModel.list.length + (listModel.isLoading ? 1 : 0),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      Provider.of<MovieListProvider>(context, listen: false).searchNextPage();
    }
  }
}
