import 'dart:convert';

class Playlist {
  String title;
  List<int> songsIndex;

  Playlist({
    this.title,
    this.songsIndex,
  });

  Playlist.fromMap(Map map) {
    this.title = map['title'];
    this.songsIndex = json.decode(map['songsIndex']).cast<int>();
  }

  Map toMap() {
    String songIndex = json.encode(this.songsIndex);
    return {
      'title': this.title,
      'songsIndex': songIndex,
    };
  }
}
