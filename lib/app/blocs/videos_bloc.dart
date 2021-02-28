import 'dart:async';
import 'package:app_youtube_bloc/app/api/api.dart';
import 'package:app_youtube_bloc/app/models/video.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;
  final StreamController<List<Video>> _videoscontroller =
      StreamController<List<Video>>();
  Stream get outVideos => _videoscontroller.stream;

  final StreamController<String> _searchcontroller = StreamController<String>();
  Sink get inSearch => _searchcontroller.sink;

  VideosBloc() {
    api = Api();

    _searchcontroller.stream.listen(_search);
  }

  void _search(String search) async {
    if (search != null) {
      _videoscontroller.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }

    _videoscontroller.sink.add(videos);
  }

  @override
  void dispose() {
    _videoscontroller.close();
    _searchcontroller.close();
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
