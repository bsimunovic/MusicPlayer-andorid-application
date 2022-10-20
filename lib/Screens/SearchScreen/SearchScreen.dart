import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musik_rocker/Screens/HomeScreen/Widgets/MusicPlayerScreen.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  List<String> songTitles = [];
  List<String> _filterList = [];
  List<int> _filterIndexList = [];
  TextEditingController _searchview = TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  int currentSongIndex = 0;

  final GlobalKey<MusicPlayerScreenState> key =
      GlobalKey<MusicPlayerScreenState>();

  @override
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    songs.forEach((element) {
      songTitles.add(element.title);
    });
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(int isNext) {
    if (isNext == 3) {
      currentSongIndex = currentSongIndex--;
    }
    key.currentState.setSong(songs[currentSongIndex]);
  }

  _SearchScreen() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

  Widget _createSearchView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.0),
      ),
      child: TextField(
        controller: _searchview,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _createListView() {
    return Flexible(
      child: ListView.builder(
          itemCount: songTitles.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
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
              child: Card(
                color: Colors.white,
                elevation: 5.0,
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text("${songTitles[index]}"),
                ),
              ),
            );
          }),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filterIndexList = [];
    for (int i = 0; i < songTitles.length; i++) {
      String item = songTitles[i];

      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        _filterIndexList.add(i);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return Flexible(
      child: ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                currentSongIndex = index;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MusicPlayerScreen(
                      changeTrack: changeTrack,
                      songInfo: songs[_filterIndexList[currentSongIndex]],
                      key: key,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                elevation: 5.0,
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text("${_filterList[index]}"),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
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
          centerTitle: true,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  _createSearchView(),
                  _firstSearch ? _createListView() : _performSearch()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
