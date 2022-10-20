import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musik_rocker/Screens/ArtistsSongsScreen/ArtistsSongsScreen.dart';
import 'package:musik_rocker/Values/globals.dart';
import 'package:musik_rocker/Screens/HomeScreen/Widgets/MusicPlayerScreen.dart';

class ArtistsPage extends StatefulWidget {
  _ArtistsPage createState() => _ArtistsPage();
}

class _ArtistsPage extends State<ArtistsPage> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<ArtistInfo> songs = [];

  final GlobalKey<MusicPlayerScreenState> key =
      GlobalKey<MusicPlayerScreenState>();
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.getArtists();
    setState(() {
      songs = songs;
    });
  }

  Widget build(context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/type6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            child: Container(
              color: Colors.black12,
            ),
            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
          ),
        ),
        ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: songs.length,
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
                backgroundImage:
                    AssetImage(imagesUrl[Random().nextInt(imagesUrl.length)])),
            title: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Text(
                songs[index].name,
                maxLines: 2,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ArtistsSongsScreen(
                    artistInfo: songs[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
