import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:xml/xml.dart' as xml;





void main() {
  runApp(PodcastPlayer());
}

class PodcastPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podcast Player',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: App() ));
  }

}

class App extends StatelessWidget {
  const App() : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: Placeholder(),
        ),
        Flexible(
          flex: 2,
          child: AudioControls()
        ),
      ],
    );
  }
}


class AudioControls extends StatelessWidget {
  const AudioControls() : super();

  @override
  Widget build(BuildContext context) {
    return Column(
     children: <Widget>[
        PlaybackButton()
     ],
    );
  }
}


class PlaybackButton extends StatefulWidget {

  @override
  State<PlaybackButton> createState() => _PlaybackButtonState();
}

class _PlaybackButtonState extends State<PlaybackButton> {
  bool _isPlaying = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }
  void _stop() {
    player.pause();
  }

  void _play() {
    // player.setSource(AssetSource('example.mp3'));
    player.play(AssetSource('example.mp3'));
  }

  Widget build(BuildContext context) {
    return IconButton(
        icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        onPressed: () {
          if (_isPlaying) {
            _stop();
          } else {
            _play();
          }
          setState(() => _isPlaying = !_isPlaying);
        }
    );
  }
}























