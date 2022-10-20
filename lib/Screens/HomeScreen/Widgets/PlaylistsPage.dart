import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musik_rocker/Screens/PlaylistScreen/Playlist.dart';
import 'package:musik_rocker/Screens/PlaylistScreen/PlaylistScreen.dart';
import 'package:musik_rocker/Values/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistPage extends StatefulWidget {
  _PlaylistPage createState() => _PlaylistPage();
}

class _PlaylistPage extends State<PlaylistPage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = new TextEditingController();
  SharedPreferences prefs;
  List<ListTile> _listTile = [];
  List<Playlist> playlists = [];

  @override
  void initState() {
    super.initState();
    _listTile.add(_buildMainTile());
    initSharedPreferences();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadPlaylists();
  }

  void loadPlaylists() {
    List<String> sPlaylist = prefs.getStringList('playlists');

    if (sPlaylist.isNotEmpty) {
      playlists =
          sPlaylist.map((item) => Playlist.fromMap(json.decode(item))).toList();
    }
    playlists.forEach((playlist) {
      _listTile.add(_buildTile(playlist));
      print(playlist.songsIndex);
    });

    setState(() {});
  }

  void savePlaylists() {
    List<String> sPlaylist =
        playlists.map((item) => json.encode(item.toMap())).toList();
    print(sPlaylist);
    prefs.setStringList('playlists', sPlaylist);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void setPlaylist(Playlist playlist) {
    if (playlists.contains(playlist)) {
      playlists.forEach((element) {
        if (element.title == playlist.title) {
          element.songsIndex = playlist.songsIndex;
          savePlaylists();
        }
      });
    }
  }

  Widget _buildMainTile() {
    return ListTile(
      leading: Icon(Icons.add),
      title: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          "Create Playlist",
          textAlign: TextAlign.end,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              elevation: 16,
              child: Container(
                height: 250.0,
                width: 360.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Add Playlist",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.lightBlue.withAlpha(150),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: textEditingController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a playlist name'),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54.withAlpha(100),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20),
                    FlatButton(
                      onPressed: () {
                        setState(
                          () {
                            Playlist newPlaylist = Playlist(
                              title: textEditingController.text,
                              songsIndex: [],
                            );

                            _listTile.add(_buildTile(newPlaylist));
                            playlists.add(newPlaylist);
                            textEditingController.clear();
                            savePlaylists();
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTile(Playlist playlist) {
    return ListTile(
      leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              AssetImage(imagesUrl[Random().nextInt(imagesUrl.length)])),
      title: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          playlist.title,
          textAlign: TextAlign.end,
        ),
      ),
      hoverColor: Colors.brown,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              setPlaylist: setPlaylist,
              playlist: playlist,
            ),
          ),
        );
      },
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
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
        ListView.builder(
          itemCount: _listTile.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                if (index > 0) {
                  _listTile.removeAt(index);
                  playlists.removeAt(index - 1);
                  savePlaylists();
                  setState(() {});
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightBlue.withAlpha(80),
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3, top: 6),
                    child: _listTile[index],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
