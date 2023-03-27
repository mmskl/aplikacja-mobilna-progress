import 'package:get/get.dart' as getx;
import 'package:just_audio/just_audio.dart' as ja;

import 'dart:async';

import '../models/item_model.dart';



class PlayerController extends getx.GetxController {
  final rxAudioPlayer = ja.AudioPlayer().obs;

  late var currentlyPlaying = getx.Rx<ItemModel>(ItemModel());

  final currentIndex = 0.obs;
  var position = 0.0.obs;
  final episodes = [
    ItemModel(
      title: 'Episode 1',
      author: 'John Doe',
      description: 'The first episode of our podcast',
      audioUrl: 'https://raportostanieswiata.pl/wp-content/uploads/2023/03/lit_mishimaslonce_13-03-23.mp3',
      pubDate: DateTime.parse('2023-02-10 10:18:04Z'),
    ),
    ItemModel(
      title: 'Episode 2',
      author: 'Jane Smith',
      description: 'The second episode of our podcast',
      audioUrl: 'https://raportostanieswiata.pl/wp-content/uploads/2022/12/lit_oz_naziemiizraela_14-11-22.mp3',
      pubDate: DateTime.parse('2023-01-20 20:18:04Z')
    ),
  ].obs;


  ja.AudioPlayer get audioPlayer {
    return this.rxAudioPlayer.value;

  }


  // Duration get position {
  //   return this.audioPlayer.position;
  // }

  Duration get duration {
    return this.audioPlayer.duration ?? Duration();
  }


  @override
  void onInit() {
    super.onInit();

    //tests
    this.setCurrentItem(item: episodes[this.currentIndex.value]);
    // /tests


    const d = Duration(seconds: 1);
    Timer.periodic(d, (Timer timer) {
      if(this.audioPlayer.playing){
        this.updateProgressBar();
      }
    });
  }

  void play() {
    if(audioPlayer.currentIndex == null) {
      this.audioPlayer.setUrl(this.currentlyPlaying.value.audioUrl);
    }
    this.audioPlayer.play();
    this.updateProgressBar();
    this.rxAudioPlayer.refresh();
  }


  void setCurrentItem({required ItemModel item}) {
    print('before this.currentlyPlaying.value');
    print(this.currentlyPlaying.value);

    this.currentlyPlaying.value = item;


    this.currentlyPlaying.value.isPlaying = true;
    this.audioPlayer.setUrl(item.audioUrl);
    if (this.currentlyPlaying.value.length == null) {
      this.currentlyPlaying.value.length = this.audioPlayer.duration;
    }

    this.updateProgressBar();
    this.currentlyPlaying.refresh();
  }


  void pause() {
    this.audioPlayer.pause();
    this.rxAudioPlayer.refresh();
  }

  void playPause() {
    if (this.audioPlayer.playing) {
      this.pause();
    } else {
      this.play();
    }
  }

  void stop() {
    audioPlayer.stop();
  }

  void updateProgressBar() {
    this.position.value = this.rxAudioPlayer.value.position.inSeconds.toDouble();
    this.position.refresh();
  }

  void seek(Duration position) {
    this.audioPlayer.seek(position);
    this.rxAudioPlayer.refresh();
    this.updateProgressBar();
  }

  void skipToNext() {
    if (currentIndex.value < episodes.length - 1) {
      currentIndex.value++;
      this.setCurrentItem(item: episodes[currentIndex.value]);
      this.play();
    }
  }

  void skipToPrevious() {
    if (this.currentIndex.value > 0) {
      this.currentIndex.value--;
      this.setCurrentItem(item: episodes[currentIndex.value]);
      this.play();
    }
  }
}
