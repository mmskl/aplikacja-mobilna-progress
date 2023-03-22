import 'package:uuid/uuid.dart';

class ItemModel {
  ItemModel({
    this.id = null,
    this.title = '',
    this.author = '',
    this.url = '',
  });

    Uuid? id;
    String title;
    String author;
    String url;
}
