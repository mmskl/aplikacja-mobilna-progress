import 'package:flutter/material.dart';
import 'package:get/get.dart';



class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Queue'),
            tileColor: Get.currentRoute == '/queue' ? Colors.grey[300] : null,
            onTap: () {
              print(Get.currentRoute);
              Get.back();
              Get.offNamed('/queue');
            },
          ),
          ListTile(
            title: Text('Subscriptions'),
            tileColor: Get.currentRoute == '/subscriptions' ? Colors.grey[300] : null,
            onTap: () {
              Get.back();
              Get.offNamed('/subscriptions');
            },
          ),
          ListTile(
            title: Text('Author'),
            tileColor: Get.currentRoute == '/author' ? Colors.grey[300] : null,
            onTap: () {
              Get.back();
              Get.offNamed('/author');
            },
          ),
        ],
      ),
    );
  }
}
