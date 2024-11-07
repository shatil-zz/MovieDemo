import 'package:flutter/material.dart';
import 'package:movie_db_test/di/service_locator.dart';
import 'package:movie_db_test/features/provider/movie_list_provider.dart';
import 'package:movie_db_test/features/screen/movie_db_home.dart';
import 'package:provider/provider.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Demo',
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
          create: (context) {
            final provider = MovieListProvider(getIt.get());
            provider.loadAllMovies();
            return provider;
          },
          child: const MovieDBHome()),
    );
  }
}
