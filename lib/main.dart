import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart' as jab;
import 'package:intl/intl.dart';

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
    return const Scaffold(body: SafeArea(child: App()));
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 9,
          child: Placeholder(),
        ),
        Flexible(flex: 2, child: AudioControls()),
      ],
    );
  }
}

class AudioControls extends StatelessWidget {
  AudioControls() : super();

  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      PlaybackButtons(),
    ]);
  }
}

String _printDuration(Duration? duration) {
  if (duration == null) {
    return "00:00:00";
  }
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

class PlaybackButtons extends StatefulWidget {
  @override
  State<PlaybackButtons> createState() => _PlaybackButtonsState();
}

class _PlaybackButtonsState extends State<PlaybackButtons> {
  bool _isPlaying = false;
  AudioPlayer player = AudioPlayer();

  Duration? _duration;

  @override
  void initState() {
    super.initState();
  }

  void _fastForward() {
    if (_duration != null) {
      // player.seek(Duration(seconds: (_duration?.inSeconds ?? 0) + 5));
      player.seek(Duration(seconds: 20));
      print(player.duration);
    } else
      player.seek(Duration(seconds: 0));
  }

  double getDurationInSeconds() {
    int secs = _duration?.inSeconds ?? 0;
    return secs.toDouble();
  }

  void _fastRewind() {
    if ((_duration?.inSeconds ?? 0) < 0) {
      player.seek(Duration(seconds: 0));
    } else {
      player.seek(Duration(seconds: ((_duration?.inSeconds ?? 0) - 5)));
    }
  }

  void _play() async {
    _duration = await player.setUrl('asset:example.mp3');
    await player.play();
    print(getDurationInSeconds());
  }

  void _pause() async {
    await player.pause();
    print(_printDuration(_duration));
  }

  void _seekToPosition() {}

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
          Row(children: [
            Slider(
                value: 0,
                max: getDurationInSeconds(),
                onChanged: (double secs) {
                  setState(() {
                    player.seek(Duration(seconds: secs.round()));
                  });
                }),
            Text(_printDuration(_duration)),
          ]),
          Row(children: [
            // Opens volume slider dialog
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "Adjust volume",
                  divisions: 10,
                  min: 0.0,
                  max: 1.0,
                  // value: player.volume,
                  stream: player.volumeStream,
                  onChanged: player.setVolume,
                );
              },
            ),

            IconButton(onPressed: _fastRewind, icon: Icon(Icons.fast_rewind)),

            /// This StreamBuilder rebuilds whenever the player state changes, which
            /// includes the playing/paused state and also the
            /// loading/buffering/ready state. Depending on the state we show the
            /// appropriate button or loading indicator.
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 64.0,
                    height: 64.0,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 64.0,
                    onPressed: _play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 64.0,
                    onPressed: _pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 64.0,
                    onPressed: () => player.seek(Duration.zero),
                  );
                }
              },
            ),
            IconButton(onPressed: _fastForward, icon: Icon(Icons.fast_forward)),
            // Opens speed slider dialog
            StreamBuilder<double>(
              stream: player.speedStream,
              builder: (context, snapshot) => IconButton(
                icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  showSliderDialog(
                    context: context,
                    title: "Adjust speed",
                    divisions: 20,
                    min: 0.6,
                    max: 2.2,
                    // value: player.speed,
                    stream: player.speedStream,
                    onChanged: player.setSpeed,
                  );
                },
              ),
            ),
          ])
    ]));

    // return Column(
    //   children: [
    //     Slider(
    //         value: 0,
    //         onChanged: (double secs) {
    //           setState(() {
    //             player.seek(Duration(seconds: secs.round()));
    //           });
    //         },
    //         max: getDurationInSeconds()),
    //     Row(children: [
    //       IconButton(onPressed: _fastRewind, icon: Icon(Icons.fast_rewind)),
    //       IconButton(
    //           icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
    //           onPressed: () {
    //             if (_isPlaying) {
    //               _pause();
    //             } else {
    //               _play();
    //             }
    //             setState(() {
    //               _isPlaying = !_isPlaying;
    //             });
    //           }),
    //     ])
    //   ],
    // );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              // value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                // value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix'),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
