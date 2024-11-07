import 'package:flutter/material.dart';
import 'package:movie_db_test/features/model/movie_list_model.dart';
import 'package:movie_db_test/features/repository/movie_repository.dart';
import 'package:movie_db_test/features/widget/movie_list.dart';

class MovieListProvider extends ChangeNotifier {
  String searchText = '';
  MovieListModel topRatedMovies = MovieListModel();
  MovieListModel nowPlayingMovies = MovieListModel();
  MovieListModel upcomingMovies = MovieListModel();
  MovieListModel searchMovies = MovieListModel();

  MovieRepository repository;

  MovieListProvider(this.repository);

  searchAllMovies(String searchText) {
    this.searchText = searchText;
    searchMovies = MovieListModel();
    if (searchText.trim().isNotEmpty) {
      searchNextPage();
    } else {
      notifyListeners();
    }
  }

  searchNextPage() async {
    notifyListeners();
    searchMovies.isLoading = true;
    searchMovies.error = null;
    Map? response =
        await repository.searchMovies(searchMovies.pageCount + 1, searchText);
    searchMovies.updateFromResponse(response);
    searchMovies.isLoading = false;
    notifyListeners();
  }

  loadAllMovies() {
    topRatedMovies = MovieListModel();
    nowPlayingMovies = MovieListModel();
    upcomingMovies = MovieListModel();
    searchMovies = MovieListModel();
    fetchMovies(MovieType.topRated);
    fetchMovies(MovieType.nowPlaying);
    fetchMovies(MovieType.upcoming);
  }

  fetchMovies(MovieType type) async {
    MovieListModel selectedModel = getSelectedModel(type);
    notifyListeners();
    selectedModel.isLoading = true;
    selectedModel.error = null;
    Map? response =
        await repository.fetchMovies(type, selectedModel.pageCount + 1);
    selectedModel.updateFromResponse(response);
    selectedModel.isLoading = false;
    notifyListeners();
  }

  MovieListModel getSelectedModel(MovieType type) {
    switch (type) {
      case MovieType.topRated:
        return topRatedMovies;
      case MovieType.nowPlaying:
        return nowPlayingMovies;
      case MovieType.upcoming:
        return upcomingMovies;
    }
  }
}
