import 'dart:ui';

import 'package:app_youtube_bloc/app/api/api.dart';
import 'package:app_youtube_bloc/app/blocs/favorite_bloc.dart';
import 'package:app_youtube_bloc/app/models/video.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'FAVORITOS',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[400],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<Map<String, Video>>(
          initialData: {},
          stream: bloc.outFavorite,
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data.values.map((value) {
                return InkWell(
                  onTap: () {
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: API_KEY,
                        videoId: value.id,
                        backgroundColor: Colors.white);
                  },
                  onLongPress: () {
                    bloc.toggleFavorite(value);
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.fromLTRB(2, 0, 5, 0),
                        width: 100,
                        height: 60,
                        child: Image.network(value.thumb),
                      ),
                      Expanded(
                          child: Text(
                        value.title,
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                      )),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
