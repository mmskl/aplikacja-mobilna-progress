import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/queue_controller.dart';
import './main_drawer.dart';

class QueuePage extends GetView<QueueController>
{
  QueuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("APP DRAWER")),
      body: Center(
        child: Text('Queue'),
      ),
      drawer: MainDrawer(),
    );
  }
}


