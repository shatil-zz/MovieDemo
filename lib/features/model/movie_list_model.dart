import 'package:movie_db_test/features/model/movie_item.dart';

class MovieListModel {
  String? error;
  bool isLoading = false;
  List<MovieItem> list = [];
  int pageCount = 0;

  updateFromResponse(Map? response) {
    if (response == null) {
      error = "Error happened";
    } else {
      pageCount = response["page"];
      for (dynamic item in response["results"]) {
          list.add(MovieItem.fromMap(item));
      }
    }
  }
}
