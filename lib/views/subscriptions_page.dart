import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/subscriptions_controller.dart';
import './main_drawer.dart';

class SubscriptionsPage extends GetView<SubscriptionsController>
{
  SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("APP DRAWER")),
      body: Center(
        child: Text('subscriptions'),
      ),
      drawer: MainDrawer(),
    );
  }
}


