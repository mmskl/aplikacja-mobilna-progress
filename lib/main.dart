// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:xml/xml.dart' as xml;
// import 'package:just_audio_background/just_audio_background.dart' as jab;
// import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'player.dart';


// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as pb;

void main() {
  runApp(PodcastPlayer());
}

class PodcastPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Podcast Player',
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => QueuePage()),
        GetPage(name: "/subscriptions", page: () => TestPage()),
        GetPage(name: "/author", page: () => TestPage()),
      ],
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}



class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
        actions: <Widget>[
          TextButton(
            // style: style,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text("main_message"),
          ),
        ],
      ),
      body: Placeholder(),
      drawer: NavDrawer(),
      );
  }
}





class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        /* padding: EdgeInsets.zero, */
        children: <Widget>[
          Container(
            height: 55,
            child: DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Game'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/')},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Hall of Fame'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Placeholder()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Placeholder()));
            },
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}






String _printDuration(Duration? duration) {
  print(duration);

  if (duration == null) {
    return "00:01:00";
  }
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

