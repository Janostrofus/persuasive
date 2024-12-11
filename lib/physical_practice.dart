import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'breathing_page.dart'; // Import your BreathingPage class here
import 'main.dart'; // Import your MainMenu class here

class PhysicalPractice extends StatefulWidget {
  const PhysicalPractice({super.key});

  @override
  State<PhysicalPractice> createState() => _PhysicalPracticeState();
}

class _PhysicalPracticeState extends State<PhysicalPractice> {
  late YoutubePlayerController _controller;
  bool videoFinished = false; // Track whether the video has finished

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=OvICfrfnnxA")!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Add a listener to detect when the video ends

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Physical Practice"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            onReady: () {
              _controller.addListener(() {
                if (_controller.value.isReady &&
                    !_controller.value.isPlaying &&
                    _controller.value.position >= _controller.metadata.duration) {
                  print(_controller.value.position);
                  print(_controller.metadata.duration);
                  setState(() {
                    videoFinished = true; // Mark the video as finished
                  });
                }
              });
              print('Player is ready.');
            },
          ),
          if (videoFinished) // Show message and button when the video ends
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Good Job doing Yoga! After finishing go back to our breathing exercise.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BreathingPage(),
                        ),
                      );
                    },
                    child: const Text("Go to Breathing Exercise"),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainMenu()),
                (route) => false,
          );
        },
        tooltip: 'Go to Home',
        child: const Icon(Icons.home),
      ),
    );
  }
}
