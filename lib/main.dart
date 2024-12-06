import 'package:flutter/material.dart';
import 'package:mindfulness/memory_training.dart';
import 'package:mindfulness/physical_practice.dart';
import 'package:mindfulness/progressive_muscle_relaxation.dart';
import 'breathing_page.dart';

void main() {
  runApp(const MindfulnessApp());
}

class MindfulnessApp extends StatelessWidget {
  const MindfulnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfulness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness Exercises'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ExerciseTile(
            title: 'Breathing',
            color: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BreathingPage()),
              );
            },
          ),
          ExerciseTile(
            title: 'Progressive Muscle Relaxation (PMR)',
            color: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProgressiveMuscleRelaxation()),
              );
            },
          ),
          ExerciseTile(
            title: 'Memory Training',
            color: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MemoryTraining()),
              );
            },
          ),
          ExerciseTile(
            title: 'Physical Practice',
            color: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhysicalPractice()),
              );
            },
          ),
          // Add more tiles for additional exercises
        ],
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  ExerciseTile({super.key, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}