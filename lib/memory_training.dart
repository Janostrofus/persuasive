import 'package:flutter/material.dart';
import 'dart:math';

class MemoryTraining extends StatefulWidget {
  const MemoryTraining({super.key});

  @override
  State<MemoryTraining> createState() => _MemoryTrainingState();
}

class _MemoryTrainingState extends State<MemoryTraining> {
  List<bool> gridStatus = List.generate(9, (_) => false); // 3x3 grid (9 tiles)
  List<int> sequence = [];
  int currentStep = 0;
  final int sequenceLength = 5;

  @override
  void initState() {
    super.initState();
    generateUniqueRandomSequence();
  }

  void generateUniqueRandomSequence() {
    final random = Random();
    List<int> allIndices = List.generate(9, (index) => index)..shuffle(random);

    setState(() {
      sequence = allIndices.sublist(0, sequenceLength);
      currentStep = 0;
      gridStatus = List.generate(9, (_) => false);
    });

    debugPrint('Generated Sequence: $sequence');
    assert(sequence.length == sequenceLength, 'Sequence length is incorrect!');
  }

  void handleTileTap(int index) {
    setState(() {
      if (currentStep < sequence.length && index == sequence[currentStep]) {
        gridStatus[index] = true;
        currentStep++;

        if (currentStep == sequence.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Good Job! Sequence completed!")),
          );
          resetGrid();
        }
      } else if (currentStep < sequence.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect! Try again.")),
        );
        resetGrid();
      }
    });
  }

  void resetGrid() {
    setState(() {
      gridStatus = List.generate(9, (_) => false);
      currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cogmed Memory Exercise - 3x3"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => handleTileTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: gridStatus[index] ? Colors.green : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: generateUniqueRandomSequence,
              child: const Text("Generate New Sequence"),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: MemoryTraining()));