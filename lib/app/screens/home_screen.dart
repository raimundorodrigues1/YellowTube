import 'package:app_youtube_bloc/app/blocs/favorite_bloc.dart';
import 'package:app_youtube_bloc/app/blocs/videos_bloc.dart';
import 'package:app_youtube_bloc/app/delegates/data_search.dart';
import 'package:app_youtube_bloc/app/models/video.dart';
import 'package:app_youtube_bloc/app/screens/favorites_screen.dart';
import 'package:app_youtube_bloc/app/widgets/video_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<VideosBloc>();
    final blocfav = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          height: 30,
          child: Image.asset('lib/app/images/youtube.png'),
          alignment: Alignment.centerLeft,
        ),
        elevation: 0,
        backgroundColor: Colors.amber[400],
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: blocfav.outFavorite,
              initialData: {},
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    "${snapshot.data.length}",
                    style: TextStyle(color: Colors.black),
                  );
                else
                  return Container();
              },
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.star,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FavoritesScreen()));
              }),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () async {
                String result =
                    await showSearch(context: context, delegate: DataSearch());

                if (result != null) {
                  bloc.inSearch.add(result);
                }
              })
        ],
      ),
      body: StreamBuilder(
          stream: bloc.outVideos,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  } else if (index > 1) {
                    bloc.inSearch.add(null);
                    return Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'lib/app/images/progress.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            else
              return Container();
          }),
    );
  }
}
