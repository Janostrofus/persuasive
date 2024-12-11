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
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ExerciseTile> exercises = [
      ExerciseTile(
        title: 'Breathing',
        icon: Icons.air,
        color: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BreathingPage()),
          );
        },
      ),
      ExerciseTile(
        title: 'Progressive Muscle Relaxation (PMR)',
        icon: Icons.self_improvement,
        color: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProgressiveMuscleRelaxation()),
          );
        },
      ),
      ExerciseTile(
        title: 'Memory Training',
        icon: Icons.psychology,
        color: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MemoryTraining()),
          );
        },
      ),
      ExerciseTile(
        title: 'Physical Practice',
        icon: Icons.directions_run,
        color: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PhysicalPractice()),
          );
        },
      ),
      // Add more tiles for additional exercises
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness Exercises'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: (exercises.length / 2).ceil(),
        itemBuilder: (context, index) {
          final int firstIndex = index * 2;
          final int secondIndex = firstIndex + 1;

          return Row(
            children: <Widget>[
              Expanded(child: exercises[firstIndex]),
              if (secondIndex < exercises.length) Expanded(child: exercises[secondIndex]),
            ],
          );
        },
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ExerciseTile({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        height: 150.0,  // Adjust the height as needed
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

