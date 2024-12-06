import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ProgressiveMuscleRelaxation extends StatefulWidget {
  const ProgressiveMuscleRelaxation({super.key});

  @override
  State<ProgressiveMuscleRelaxation> createState() =>
      _ProgressiveMuscleRelaxationState();
}

class _ProgressiveMuscleRelaxationState
    extends State<ProgressiveMuscleRelaxation> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('PMR.mp3'));
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _resetAudio() async {
    await _audioPlayer.seek(Duration.zero);
    setState(() {
      _currentPosition = Duration.zero;
      _isPlaying = false;
    });
  }

  Future<void> _seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PMR"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _playPauseAudio,
              child: Text(_isPlaying ? 'Pause Audio' : 'Play Audio'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetAudio,
              child: const Text('Reset Audio'),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _currentPosition.inSeconds.toDouble(),
              max: _totalDuration.inSeconds.toDouble(),
              onChanged: (value) {
                _seekAudio(Duration(seconds: value.toInt()));
              },
            ),
            Text(
              '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Use the controls to play, pause, reset, or navigate the Progressive Muscle Relaxation audio.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
