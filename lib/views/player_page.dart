import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';

class PlayerPage extends GetView<PlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("${controller.currentlyPlaying.value.title}")),
      ),
      body: Column(
        children: [
          paddingTop(20),
          cover(),
          Expanded(
            flex: 2,
            child: info(),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                slider(),
                audioPlayerButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget paddingTop(double px) {
    return Padding(padding: EdgeInsets.only(top: px));
  }

  Widget cover() {
    return Expanded(
      flex: 7,
      child: Center(
          child: Container(child: Placeholder(), width: 300, height: 300)),
    );
  }

  Widget info() {
    return Column(
      children: [
        Obx(() => Text("${controller.currentlyPlaying.value.author}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ))),
        Obx(() => Text("${controller.currentlyPlaying.value.pubDate}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ))),
        Obx(() => Text(
              "${controller.currentlyPlaying.value.title}",
              style: TextStyle(
                fontSize: 18,
              ),
            )),
        paddingTop(10),
        Obx(() => Text("${controller.currentlyPlaying.value.description}",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ))),
      ],
    );
  }

  Widget slider() {
    return Obx(() => Slider(
          value: controller.position.value,
          max: controller.rxAudioPlayer.value.duration?.inSeconds.toDouble() ??
              0.0,
          onChanged: (value) =>
              controller.seek(Duration(seconds: value.toInt())),
        ));
  }

  Widget audioPlayerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: () => controller.skipToPrevious(),
        ),
        Obx(() => IconButton(
              icon: Icon(controller.rxAudioPlayer.value.playing
                  ? Icons.pause
                  : Icons.play_arrow),
              onPressed: () => controller.playPause(),
            )),
        IconButton(
          icon: Icon(Icons.skip_next),
          onPressed: () => controller.skipToNext(),
        ),
      ],
    );
  }
}
