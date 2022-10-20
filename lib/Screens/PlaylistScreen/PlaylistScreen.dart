import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musik_rocker/Screens/HomeScreen/Widgets/MusicPlayerScreen.dart';
import 'package:musik_rocker/Values/globals.dart';

import 'AddToPlaylistScreen.dart';
import 'Playlist.dart';

// ignore: must_be_immutable
class PlaylistScreen extends StatefulWidget {
  Function setPlaylist;
  Playlist playlist;

  PlaylistScreen({
    this.playlist,
    this.setPlaylist,
  });

  _PlaylistScreen createState() => _PlaylistScreen();
}

class _PlaylistScreen extends State<PlaylistScreen> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  List<SongInfo> allSongs = [];
  List<int> repeatingRandomNumberCheckerList = [];
  List<int> songsHistoryList = [];
  int currentSongIndex = 0;
  final GlobalKey<MusicPlayerScreenState> key =
      GlobalKey<MusicPlayerScreenState>();

  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    allSongs = await audioQuery.getSongs();

    setState(() {
      allSongs = allSongs;
    });
    getPlaylist();
  }

  getPlaylist() {
    if (widget.playlist.songsIndex.isNotEmpty) {
      widget.playlist.songsIndex.forEach((element) {
        songs.add(allSongs[element]);
      });
    }
  }

  addSongsToPlaylist(List<SongInfo> playlist, List<int> songsIndex) {
    List<String> titles = [];
    songs.forEach((element) {
      titles.add(element.title);
    });
    setState(() {
      int i = 0;
      playlist.forEach((element) {
        if (!titles.contains(element.title)) {
          songs.add(element);
          widget.playlist.songsIndex.add(songsIndex[i]);
        }
        i++;
      });
      widget.setPlaylist(widget.playlist);
    });
  }

  removeFromPlaylist(int index) {
    widget.playlist.songsIndex.removeAt(index);
    widget.setPlaylist(widget.playlist);
    setState(() {});
  }

  void changeTrack(int isNext) {
    if (songsHistoryList.length > 15) {
      songsHistoryList.removeAt(0);
    }
    if (isNext == 0) {
      if (currentSongIndex != songs.length - 1) {
        songsHistoryList.add(currentSongIndex);
        currentSongIndex++;
      }
    } else if (isNext == 1) {
      if (onShuffle) {
        currentSongIndex = songsHistoryList[songsHistoryList.length - 1];
        songsHistoryList.removeAt(songsHistoryList.length - 1);
      } else if (currentSongIndex != 0) {
        currentSongIndex--;
      }
    } else if (isNext == 2) {
      songsHistoryList.add(currentSongIndex);
      int randomNumber = Random().nextInt(songs.length - 1);
      while (repeatingRandomNumberCheckerList.contains(randomNumber)) {
        randomNumber = Random().nextInt(songs.length - 1);
      }
      currentSongIndex = randomNumber;
      repeatingRandomNumberCheckerList.add(randomNumber);
      if (repeatingRandomNumberCheckerList.length >= 7) {
        repeatingRandomNumberCheckerList.clear();
      }
    } else if (isNext == 3) {
      currentSongIndex = currentSongIndex--;
    }
    key.currentState.setSong(songs[currentSongIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.playlist.title),
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
        children: <Widget>[
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
          Stack(
            children: [
              ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: songs.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    currentSongIndex = index;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerScreen(
                          changeTrack: changeTrack,
                          songInfo: songs[currentSongIndex],
                          key: key,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    removeFromPlaylist(index);
                    songs.removeAt(index);
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
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddToPlaylistScreen(
                            onSongsAdded: addSongsToPlaylist,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_circle_outline_outlined,
                      size: 60,
                      color: Colors.lightBlue.withAlpha(80),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
