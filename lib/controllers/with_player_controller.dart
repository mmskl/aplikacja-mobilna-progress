import 'package:get/get.dart';
import '../models/player_model.dart';
import '../models/item_model.dart';

class WithPlayerController extends GetxController {
  final player = PlayerModel().obs;

  void play_now(ItemModel im) {

    this.player.value.isPlaying = true;
    this.player.value.author = im.author;
    print(this.player.value.author);
    this.player.value.title = im.title;
    this.player.value.url = im.url;
    this.player.refresh();
  }

}
