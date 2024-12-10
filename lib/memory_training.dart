import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart'; // Import your MainMenu class
import 'physical_practice.dart'; // Import the PhysicalPractice page

class MemoryTraining extends StatefulWidget {
  const MemoryTraining({super.key});

  @override
  State<MemoryTraining> createState() => _MemoryTrainingState();
}

class _MemoryTrainingState extends State<MemoryTraining> {
  List<bool> gridStatus = List.generate(16, (_) => false); // 4x4 grid (16 tiles)
  List<int> sequence = [];
  int currentStep = 0;
  int sequenceLength = 5;
  bool showDialogFirstTime = true;
  bool showNextButton = false; // Control visibility of the next button

  @override
  void initState() {
    super.initState();
    generateUniqueRandomSequence();
    Future.delayed(Duration.zero, showIntroductionDialog);
  }

  void generateUniqueRandomSequence() {
    final random = Random();

    setState(() {
      sequence = List.generate(sequenceLength, (_) => random.nextInt(16));
      currentStep = 0;
      gridStatus = List.generate(16, (_) => false);
      showNextButton = false; // Reset next button visibility
    });

    debugPrint('Generated Sequence: $sequence');
    assert(sequence.length == sequenceLength, 'Sequence length is incorrect!');
  }

  Future<void> showSequence() async {
    for (int i = 0; i < sequence.length; i++) {
      setState(() {
        gridStatus = List.generate(16, (_) => false);
        gridStatus[sequence[i]] = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        gridStatus[sequence[i]] = false;
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void handleTileTap(int index) {
    setState(() {
      if (currentStep < sequence.length && index == sequence[currentStep]) {
        gridStatus = List.generate(16, (_) => false);
        gridStatus[index] = true;
        currentStep++;

        if (currentStep == sequence.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Good Job! Sequence completed!")),
          );
          setState(() {
            showNextButton = true; // Show the button upon success
          });
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
      gridStatus = List.generate(16, (_) => false);
      currentStep = 0;
    });
  }

  void showIntroductionDialog() {
    if (showDialogFirstTime) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dialog from being dismissed by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Welcome to Cogmed Memory Exercise"),
            content: const Text(
                "The game will display a sequence of highlighted tiles. "
                    "Remember the sequence and tap the tiles in the same order. "
                    "Good luck!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Proceed"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Future.delayed(const Duration(seconds: 1));
                  showSequence();
                },
              ),
            ],
          );
        },
      );
      showDialogFirstTime = false;
    } else {
      showSequence();
    }
  }

  void showNextExerciseNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Good Job!"),
          content: const Text("Let's move to the next exercise."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cogmed Memory Exercise - 4x4"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double gridSize = min(constraints.maxWidth, constraints.maxHeight) * 0.8;

                return Center(
                  child: SizedBox(
                    width: gridSize,
                    height: gridSize,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: 16,
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
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (sequenceLength > 3) {
                          setState(() {
                            sequenceLength--;
                          });
                        }
                      },
                    ),
                    Text(
                      'Difficulty: $sequenceLength',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (sequenceLength < 10) {
                          setState(() {
                            sequenceLength++;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    generateUniqueRandomSequence();
                    showSequence();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Generate New Sequence"),
                ),
                const SizedBox(height: 20),
                if (showNextButton) // Conditional rendering for the Next button
                  ElevatedButton(
                    onPressed: () {
                      showNextExerciseNotification();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhysicalPractice(),
                          ),
                        );
                      });
                    },
                    child: const Text("Go to Physical Practice"),
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
            MaterialPageRoute(builder: (context) => MainMenu()),
                (route) => false,
          );
        },
        child: const Icon(Icons.home),
        tooltip: 'Go to Home',
      ),
    );
  }
}
