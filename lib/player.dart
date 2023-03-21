import 'package:just_audio/just_audio.dart' as ja;
import 'package:flutter/material.dart';


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

  ja.AudioPlayer player = ja.AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      PlaybackButtons(),
    ]);
  }
}



class PlaybackButtons extends StatefulWidget {
  @override
  State<PlaybackButtons> createState() => _PlaybackButtonsState();
}

class _PlaybackButtonsState extends State<PlaybackButtons> {
  bool _isPlaying = false;
  ja.AudioPlayer player = ja.AudioPlayer();

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
  }

  void _seekToPosition() {}

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [


          Row(children: [


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
            StreamBuilder<ja.PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ja.ProcessingState.loading ||
                    processingState == ja.ProcessingState.buffering) {
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
                } else if (processingState != ja.ProcessingState.completed) {
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
                icon: Text("${snapshot.data?.toStringAsFixed(1)}",
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
