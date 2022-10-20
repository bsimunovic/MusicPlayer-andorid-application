import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musik_rocker/Values/globals.dart';

// ignore: must_be_immutable
class MusicPlayerScreen extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;

  final GlobalKey<MusicPlayerScreenState> key;
  MusicPlayerScreen({
    this.songInfo,
    this.changeTrack,
    this.key,
  }) : super(key: key);
  MusicPlayerScreenState createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  String randomImage = imagesUrl[Random().nextInt(imagesUrl.length)];
  double minimumValue = 0.0;
  double maximumValue = 0.0;
  double currentValue = 0.0;
  String currentTime = '';
  String endTime = '';
  bool isPlaying = false;
  bool onRepeat = false;

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await audioPlayer.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = audioPlayer.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    audioPlayer.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      if (onRepeat) {
        if (currentValue >= maximumValue) {
          widget.changeTrack(3);
        }
      } else if (onShuffle) {
        if (currentValue >= maximumValue) {
          widget.changeTrack(2);
        }
      } else {
        if (currentValue >= maximumValue) {
          widget.changeTrack(0);
        }
      }
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      audioPlayer.play();
    } else {
      audioPlayer.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
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
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(randomImage),
                      radius: 130,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 20, 20, 0),
                          child: Text(
                            widget.songInfo.title,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              widget.songInfo.artist,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25),
                          child: Slider(
                            inactiveColor: Colors.lightBlue.withAlpha(40),
                            activeColor: Colors.lightBlue.withAlpha(180),
                            min: minimumValue,
                            max: maximumValue,
                            value: currentValue,
                            onChanged: (value) {
                              currentValue = value;

                              audioPlayer.seek(
                                Duration(
                                  milliseconds: currentValue.round(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(0, -33, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentTime,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  endTime,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  onShuffle
                                      ? Icons.stop_outlined
                                      : Icons.shuffle,
                                  color: Colors.black54.withAlpha(130),
                                  size: 35,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    onShuffle = !onShuffle;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.skip_previous,
                                  color: Colors.black54.withAlpha(130),
                                  size: 45,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (widget.changeTrack != null) {
                                    widget.changeTrack(1);
                                    randomImage = imagesUrl[
                                        Random().nextInt(imagesUrl.length)];
                                  }
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause_outlined
                                      : Icons.play_arrow_outlined,
                                  color: Colors.black54.withAlpha(130),
                                  size: 65,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  changeStatus();
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.skip_next,
                                  color: Colors.black54.withAlpha(130),
                                  size: 45,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (widget.changeTrack != null) {
                                    if (onShuffle) {
                                      widget.changeTrack(2);
                                      randomImage = imagesUrl[
                                          Random().nextInt(imagesUrl.length)];
                                    } else {
                                      widget.changeTrack(0);
                                      randomImage = imagesUrl[
                                          Random().nextInt(imagesUrl.length)];
                                    }
                                  }
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  onRepeat ? Icons.stop_outlined : Icons.repeat,
                                  color: Colors.black54.withAlpha(130),
                                  size: 35,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    onRepeat = !onRepeat;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
