import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/author_controller.dart';
import './main_drawer.dart';

class AuthorPage extends GetView<AuthorController>
{
  AuthorPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("APP DRAWER")),
      body: Center(
        child: Text('authors'),
      ),
      drawer: MainDrawer(),
    );
  }
}
