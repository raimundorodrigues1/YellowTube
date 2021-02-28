import 'dart:async';
import 'dart:convert';

import 'package:app_youtube_bloc/app/models/video.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites = {};

  final _favoriteController = BehaviorSubject<Map<String, Video>>();

  Stream<Map<String, Video>> get outFavorite => _favoriteController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((preferences) {
      if (preferences.getKeys().contains("favorites")) {
        _favorites =
            json.decode(preferences.getString("favorites")).map((key, value) {
          return MapEntry(key, Video.fromJson(value));
        }).cast<String, Video>();
        _favoriteController.add(_favorites);
      }
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id))
      _favorites.remove(video.id);
    else
      _favorites[video.id] = video;

    _favoriteController.sink.add(_favorites);

    _saveFavorites();
  }

  void _saveFavorites() {
    SharedPreferences.getInstance().then((preferences) {
      preferences.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favoriteController.close();
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
