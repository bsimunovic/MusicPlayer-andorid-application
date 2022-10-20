import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musik_rocker/Values/globals.dart';
import 'package:musik_rocker/Screens/HomeScreen/Widgets/MusicPlayerScreen.dart';

class Tracks extends StatefulWidget {
  _Tracks createState() => _Tracks();
}

class _Tracks extends State<Tracks> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
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
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
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
                songs[index].title,
                maxLines: 2,
              ),
            ),
            subtitle: Text(songs[index].artist),
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
          ),
        ),
      ],
    );
  }
}
