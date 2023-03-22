import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/item_model.dart';
import './with_player_controller.dart';

class QueueController extends WithPlayerController {

  Rx<List<ItemModel>>queueList = Rx<List<ItemModel>>([]);
  Rx<int> queueCount = 0.obs;

  void addToQueueList(String title, String author, String url) {

    var q = ItemModel(
        id: Uuid(),
        title: title,
        author: author,
        url: url,
      );

    this.queueList.value.add(q);
    this.queueCount.value = queueList.value.length;

    this.queueCount.refresh();
    this.queueList.refresh();


  }


  void play(Uuid? id) {
    var _queueItem = queueList.value.firstWhere((item) => (item.id == id));
    print(_queueItem);
    print(_queueItem.title);
    print(_queueItem.author);
    print(_queueItem.toString());
    this.play_now(_queueItem);
  }

}
