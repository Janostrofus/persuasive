import 'package:flutter/material.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _isAnimating = false;
  String _breathingText = 'Start';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // 4 seconds inhale, 2 seconds hold, 4 seconds exhale
      vsync: this,
    );

    // Define the animation to grow and shrink the ball
    _animation = Tween<double>(begin: 200, end: 300).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Make the animation repeat in reverse (inhale/exhale cycle)
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathingText = 'Hold';
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _breathingText = 'Breathe out';
          });
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _breathingText = 'Hold';
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _breathingText = 'Breathe in';
          });
          _controller.forward();
        });
      }
    });

    // Show instructions pop-up when the page is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) => _showInstructions());
  }

  void _startBreathingExercise() {
    setState(() {
      _isAnimating = true;
      _breathingText = 'Breathe in';
    });
    _controller.forward();
  }

  void _stopBreathingExercise() {
    setState(() {
      _isAnimating = false;
      _breathingText = 'Start';
    });
    _controller.stop();
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Breathing Exercise Instructions'),
          content: Text(
            'Sit or lie down in a comfortable position.\n'
            'Close your eyes and take a few deep breaths,\n'
            'inhaling through your nose and exhaling through\n'
            'your mouth. Shift your focus to the natural\n'
            'rhythm of your breath. Notice the sensations\n'
            'of each inhale and exhale, observing how your\n'
            'chest or belly rises and falls. If your mind wanders,\n'
            'gently bring your focus back to your breathing.\n'
            'Duration: 5–10 minutes daily.',
            textAlign: TextAlign.justify, // Block align text
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        title: Text('Breathing Exercise'),
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
                      if (_controller.isAnimating && _controller.value < 0.5) {
                        _breathingText = 'Breathe in';
                      } else if (_controller.isAnimating && _controller.value > 0.5) {
                        _breathingText = 'Breathe out';
                      }
                      return Container(
                        width: _animation.value,
                        height: _animation.value,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                  Text(
                    _breathingText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40), // Adjust the padding as needed
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Adjust button size
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: _isAnimating ? _stopBreathingExercise : _startBreathingExercise,
              child: Text(_isAnimating ? 'Stop' : 'Start'),
            ),
          ),
        ],
      ),
    );
  }
}
