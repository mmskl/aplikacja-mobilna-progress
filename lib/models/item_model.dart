import 'package:uuid/uuid.dart';

class ItemModel {
  Uuid? id;
  String title;
  String author;
  String url;
  String description;
  bool isPlaying = false;
  Duration? length = Duration();
  DateTime? pubDate = DateTime(0);
  String? avatar = null;

  // constructor
  ItemModel({
    this.id = null,
    this.title = '',
    this.author = '',
    this.url = '',
    this.description = '',
    this.pubDate = null,
    this.length = null,
  });

  ItemModel from(ItemModel item) {
    this.id = item.id;
    this.title = item.title;
    this.author = item.author;
    this.url = item.url;
    this.description = item.description;
    return this;
  }
}
