import 'package:app_youtube_bloc/app/api/api.dart';
import 'package:app_youtube_bloc/app/blocs/favorite_bloc.dart';
import 'package:app_youtube_bloc/app/blocs/videos_bloc.dart';
import 'package:app_youtube_bloc/app/screens/home_screen.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

void main() {
  Api api = Api();
  api.search('');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => VideosBloc()), Bloc((i) => FavoriteBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
