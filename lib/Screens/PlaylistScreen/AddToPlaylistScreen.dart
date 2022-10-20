import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

// ignore: must_be_immutable
class AddToPlaylistScreen extends StatefulWidget {
  Function onSongsAdded;

  AddToPlaylistScreen({
    this.onSongsAdded,
  });
  _AddToPlaylistScreen createState() => _AddToPlaylistScreen();
}

class _AddToPlaylistScreen extends State<AddToPlaylistScreen> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> playlistSongs = [];
  List<SongInfo> songs = [];
  List<bool> _checked = [];
  List<int> songsIndex = [];
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  Widget build(context) {
    for (int i = 0; i < songs.length; i++) {
      _checked.add(false);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Choose songs for playlist"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue[300],
                Colors.lightGreen[200],
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
            ),
          ),
        ),
      ),
      body: Stack(
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
            itemBuilder: (context, index) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: _checked[index],
              onChanged: (bool value) {
                setState(() {
                  _checked[index] = value;
                });
              },
              title: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  songs[index].title,
                  maxLines: 2,
                ),
              ),
              subtitle: Text(songs[index].artist),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 60,
                width: 250,
                child: FlatButton(
                  color: Colors.lightBlue.withAlpha(80),
                  onPressed: () {
                    for (int index = 0; index < songs.length; index++) {
                      if (_checked[index] == true) {
                        playlistSongs.add(songs[index]);
                        songsIndex.add(index);
                      }
                    }
                    widget.onSongsAdded(playlistSongs, songsIndex);
                    Navigator.pop(context);
                  },
                  child: Text("Add to playlist"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
