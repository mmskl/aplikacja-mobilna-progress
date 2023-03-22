import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart' as ja;

import '../controllers/queue_controller.dart';
import './main_drawer.dart';

class QueuePage extends GetView<QueueController> {

  QueuePage({Key? key}) : super(key: key);

  // final queue = ListView<Widget>();

  @override
  Widget build(BuildContext context) {

        controller.addToQueueList('title', 'author', 'url');
        controller.addToQueueList(
          'TTTTTT',
          'AAAAAAAAAAAAAA',
          'UUUUUUUUUUUUURLRLRLRL',
          );


    Future.delayed(Duration(milliseconds: 3000), () {
        controller.addToQueueList('title', 'author', 'url');
        controller.addToQueueList(
          'Using Type Function',
          'Author ElevatedButton',
          'https://d3ctxlq1ktw2nl.cloudfront.net/staging/2023-2-8/c9a2e402-1e27-c4bc-18df-c4a01d1d4ea4.mp3',
          );
    });


    return Scaffold(
      appBar: AppBar(title: Text("APP DRAWER")),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Flexible(
            flex: 9,
            child: Expanded(
                child: ListView.builder(
                  itemCount: controller.queueCount.value,
                  itemBuilder: ((context, i) {
                    return ListTile(
                      title: Text(controller.queueList.value[i].title),
                      subtitle: Text(controller.queueList.value[i].author),
                      trailing: IconButton(onPressed: () => controller.play(controller.queueList.value[i].id), icon: Icon(Icons.play_arrow)),
                    );
                  }))
                ),

            // ,
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Obx(() { return Text("title: ${controller.player.value.title}, author: ${controller.player.value.author}, url: ${controller.player.value.url}");} ),
                // AudioControls(),
              ],
            )
            ),
        ],
      )
      );
  }




