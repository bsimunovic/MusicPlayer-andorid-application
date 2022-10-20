import 'package:equalizer/equalizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musik_rocker/Screens/AboutMeScreen/AboutMeScreen.dart';
import 'package:musik_rocker/Screens/HomeScreen/Widgets/ArtistsPage.dart';
import 'package:musik_rocker/Screens/HomeScreen/Widgets/PlaylistsPage.dart';
import 'Widgets/NavigationBar.dart';
import 'Widgets/TracksPage.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  PageController pageController = new PageController(initialPage: 1);
  int currentPage = 1;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
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
                  CircleAvatar(
                    backgroundColor: Colors.black12.withAlpha(80),
                    backgroundImage:
                        AssetImage('assets/images/ic_launcher.png'),
                    radius: 80,
                  ),
                ],
              ),
              ListTile(
                tileColor: Colors.grey.withAlpha(30),
                onTap: () {
                  Equalizer.open(0);
                },
                title: Text(
                  "Equalizer",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                tileColor: Colors.grey.withAlpha(30),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutMeScreen()));
                },
                title: Text(
                  "About me",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                tileColor: Colors.grey.withAlpha(30),
                onTap: () {
                  SystemNavigator.pop();
                },
                title: Text(
                  "Exit",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: NavigationBar(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue[100],
              Colors.lightGreen[100],
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            stops: [0.0, 0.8],
            tileMode: TileMode.clamp,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          onTap: (index) {
            currentPage = index;
            pageController.jumpToPage(index);
            pageController.animateToPage(
              index,
              duration: Duration(seconds: 1),
              curve: Curves.linear,
            );
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black26,
          currentIndex: currentPage,
          items: [
            BottomNavigationBarItem(
              label: "Artists",
              icon: Icon(
                Icons.queue_music_rounded,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                Icons.music_note_sharp,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: "Playlists",
              icon: Icon(
                Icons.playlist_add_outlined,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          ArtistsPage(),
          Tracks(),
          PlaylistPage(),
        ],
      ),
    );
  }
}
