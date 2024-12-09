import 'dart:async';
import 'package:flutter/material.dart';
import 'progressive_muscle_relaxation.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _isAnimating = false;
  String _breathingText = 'Start';
  bool _showNextButton = false; // Controls visibility of the next exercise button
  Timer? _timer; // Timer for showing the button

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // Inhale, hold, exhale cycle
      vsync: this,
    );

    // Animation for growing/shrinking ball
    _animation = Tween<double>(begin: 200, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _breathingText = 'Hold');
        Future.delayed(const Duration(seconds: 2), () {
          setState(() => _breathingText = 'Breathe out');
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _breathingText = 'Hold');
        Future.delayed(const Duration(seconds: 2), () {
          setState(() => _breathingText = 'Breathe in');
          _controller.forward();
        });
      }
    });

    // Show instructions popup on first load
    WidgetsBinding.instance.addPostFrameCallback((_) => _showInstructions());
  }

  void _startBreathingExercise() {
    setState(() {
      _isAnimating = true;
      _breathingText = 'Breathe in';
    });
    _controller.forward();

    // Start timer for showing the next exercise button
    _timer = Timer(const Duration(minutes: 1), () {
      setState(() => _showNextButton = true);
      _showPopup("Good Job! Let's go to the next exercise.");
    });
  }

  void _stopBreathingExercise() {
    setState(() {
      _isAnimating = false;
      _breathingText = 'Start';
    });
    _controller.stop();
    _timer?.cancel(); // Cancel timer if the user stops the exercise
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Breathing Exercise Instructions'),
          content: const Text(
            'Sit or lie down in a comfortable position.\n'
                'Close your eyes and take a few deep breaths,\n'
                'inhaling through your nose and exhaling through your mouth.\n'
                'Shift your focus to the rhythm of your breath.\n\n'
                'Duration: 5–10 minutes daily.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: _animation.value,
                        height: _animation.value,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                  Text(
                    _breathingText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed:
                  _isAnimating ? _stopBreathingExercise : _startBreathingExercise,
                  child: Text(_isAnimating ? 'Stop' : 'Start'),
                ),
                if (_showNextButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ProgressiveMuscleRelaxation(),
                        ),
                      );
                    },
                    child: const Text('Next Exercise'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
