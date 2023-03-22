import 'package:uuid/uuid.dart';

class PlayerModel {
  PlayerModel({
    this.id = null,
    this.title = '',
    this.author = '',
    this.url = '',
    this.isPlaying = false,
  });

    Uuid? id;
    String title;
    String author;
    String url;
    bool isPlaying;
}
