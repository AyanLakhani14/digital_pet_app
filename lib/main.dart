import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;

  final TextEditingController _nameController = TextEditingController();

  Timer? _timer;

  int secondsUntilHungerTick = 30;
  int happySeconds = 0; // track win condition
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (gameEnded) return;

      setState(() {
        secondsUntilHungerTick--;

        if (secondsUntilHungerTick <= 0) {
          _autoIncreaseHunger();
          secondsUntilHungerTick = 30;
        }

        // WIN tracking
        if (happinessLevel > 80) {
          happySeconds++;
          if (happySeconds >= 180) {
            _showDialog("YOU WIN 🎉", "Your pet stayed happy for 3 minutes!");
          }
        } else {
          happySeconds = 0;
        }

        // LOSS condition
        if (hungerLevel >= 100 && happinessLevel <= 10) {
          _showDialog("GAME OVER", "Your pet became too hungry and sad.");
        }
      });
    });
  }

  void _showDialog(String title, String message) {
    gameEnded = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      secondsUntilHungerTick = 30;
      happySeconds = 0;
      gameEnded = false;
    });
  }

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  String _moodStatus(int happinessLevel) {
    if (happinessLevel > 70) return "Happy";
    if (happinessLevel >= 30) return "Neutral";
    return "Unhappy";
  }

  String _moodEmoji(int happinessLevel) {
    if (happinessLevel > 70) return "😄";
    if (happinessLevel >= 30) return "🙂";
    return "😢";
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) hungerLevel = 0;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel -= 20;
    }
  }

  void _autoIncreaseHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) hungerLevel = 100;
  }

  void _setPetName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    setState(() {
      petName = newName;
    });

    _nameController.clear();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Enter pet name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _setPetName, child: Text("Set Name")),
              SizedBox(height: 20),

              Text('Name: $petName', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),

              Text(
                'Mood: ${_moodStatus(happinessLevel)} ${_moodEmoji(happinessLevel)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Text('Next hunger increase in: $secondsUntilHungerTick s'),

              SizedBox(height: 16),

              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _moodColor(happinessLevel),
                  BlendMode.modulate,
                ),
                child: Image.asset('assets/pet_image.png', height: 180),
              ),

              SizedBox(height: 16),

              Text('Happiness Level: $happinessLevel'),
              Text('Hunger Level: $hungerLevel'),

              SizedBox(height: 32),

              ElevatedButton(
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              ElevatedButton(
                onPressed: _feedPet,
                child: Text('Feed Your Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
