import 'package:example/stream_demos/pre_programmed_songs/back_in_black.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hue/flutter_hue.dart';
import 'package:just_audio/just_audio.dart';

class StreamDemosScreen extends StatelessWidget {
  StreamDemosScreen({super.key, required this.entertainmentConfiguration});

  final EntertainmentConfiguration entertainmentConfiguration;

  final AudioPlayer _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _player.stop();
          entertainmentConfiguration.flushStreamQueue();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stream Demos'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SOUND ON MESSAGE
                const Text(
                  'Make sure your sound is on!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                // BACK IN BLACK
                ElevatedButton(
                  onPressed: () {
                    try {
                      _player
                          .setAudioSource(
                        AudioSource.asset('assets/back_in_black.mp3'),
                        initialPosition: Duration.zero,
                      )
                          .then(
                        (songDuration) {
                          if (songDuration != null) {
                            entertainmentConfiguration.flushStreamQueue();
                            entertainmentConfiguration
                                .addAllToStreamQueue(BackInBlack.commands);

                            _player.play();
                          }
                        },
                      );
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow),
                      Text('Back in Black'),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // STOP BUTTON
                ElevatedButton(
                  onPressed: () {
                    _player.stop();
                    entertainmentConfiguration.flushStreamQueue();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stop),
                      Text('Stop Song'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
