// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meercast/controllers/subscriptions_controller.dart';
import 'package:meercast/views/subscriptions_page.dart';

// import 'player.dart';
import './views/queue_page.dart';
import './views/author_page.dart';
import './controllers/author_controller.dart';
import './controllers/queue_controller.dart';


void main() {
  runApp(PodcastPlayer());
}

class PodcastPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Podcast Player',
      initialRoute: "/queue",
      navigatorKey: Get.key,
      getPages: [
        GetPage(
          name: "/subscriptions",
          page: () => SubscriptionsPage(),
          binding: SubscriptionsBinding(),
          ),
        GetPage(
          name: "/author",
          page: () => AuthorPage(),
          binding: AuthorBinding(),
        ),
        GetPage(
          name: '/queue',
          page: () => QueuePage(),
          binding: QueueBinding(),
        ),
      ],
    );
  }
}

class QueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QueueController(), permanent: true);
  }
}


class SubscriptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubscriptionsController(), permanent: true);
  }
}

class AuthorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthorController(), permanent: true);
  }
}


class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
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

