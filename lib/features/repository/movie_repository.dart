import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:movie_db_test/features/widget/movie_list.dart';
import 'package:http/http.dart' as http;

@injectable
@singleton
class MovieRepository {
  Future<Map?> fetchMovies(MovieType type, int page) async {
    try {
      var url;
      Map<String, String> queryParams = {
        "api_key": "4bc53930f5725a4838bf943d02af6aa9",
        "language": "en-US",
        "page": "$page"
      };
      if (type == MovieType.topRated) {
        url =
            Uri.https('api.themoviedb.org', '/3/movie/top_rated', queryParams);
      } else if (type == MovieType.nowPlaying) {
        url = Uri.https(
            'api.themoviedb.org', '/3/movie/now_playing', queryParams);
      } else {
        url = Uri.https('api.themoviedb.org', '/3/movie/upcoming', queryParams);
      }
      var response = await http.get(url);
      if (response.statusCode == 200) return jsonDecode(response.body);
      return null;
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }

  Future<Map?> searchMovies(int page, String text) async {
    try {
      Map<String, String> queryParams = {
        "api_key": "4bc53930f5725a4838bf943d02af6aa9",
        "language": "en-US",
        "page": "$page",
        "query": "text"
      };
      var url = Uri.https('api.themoviedb.org', '/3/search/movie', queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) return jsonDecode(response.body);
      return null;
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }
}
