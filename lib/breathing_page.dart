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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // 2 seconds inhale, 2 seconds exhale
      vsync: this,
    );

    // Define the animation to grow and shrink the ball
    _animation = Tween<double>(begin: 50, end: 200).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Make the animation repeat in reverse (inhale/exhale cycle)
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  void _startBreathingExercise() {
    setState(() {
      _isAnimating = true;
    });
    _controller.forward();
  }

  void _stopBreathingExercise() {
    setState(() {
      _isAnimating = false;
    });
    _controller.stop();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _isAnimating ? _stopBreathingExercise : _startBreathingExercise,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
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
            ),
            SizedBox(height: 24),
            Text(
              _isAnimating ? 'Inhale... Exhale...' : 'Press the button to start',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isAnimating ? _stopBreathingExercise : _startBreathingExercise,
              child: Text(_isAnimating ? 'Stop' : 'Start'),
            ),
            SizedBox(height: 16),
            // Additional text below the button
            Text(
              'Sit or lie down in a comfortable position. Close your eyes and take a few deep breaths, inhaling through your nose and exhaling through your mouth.'
                  'Shift your focus to the natural rhythm of your breath. Notice the sensations of each inhale and exhale, observing how your chest or belly rises and falls.'
              'If your mind wanders, gently bring your focus back to your breathing. '
              'Duration: 5–10 minutes daily. ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
