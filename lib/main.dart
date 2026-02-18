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

  // Timers
  Timer? _countdownTimer;

  //  Countdown seconds until next hunger increase
  int secondsUntilHungerTick = 30;

  @override
  void initState() {
    super.initState();

    //  One timer runs every second:
    // - updates countdown
    // - when countdown hits 0 -> hunger increases, countdown resets to 30
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        secondsUntilHungerTick--;

        if (secondsUntilHungerTick <= 0) {
          _autoIncreaseHunger();
          secondsUntilHungerTick = 30;
        }
      });
    });
  }

  // Mood color
  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _moodStatus(int happinessLevel) {
    if (happinessLevel > 70) {
      return "Happy";
    } else if (happinessLevel >= 30) {
      return "Neutral";
    } else {
      return "Unhappy";
    }
  }

  String _moodEmoji(int happinessLevel) {
    if (happinessLevel > 70) {
      return "😄";
    } else if (happinessLevel >= 30) {
      return "🙂";
    } else {
      return "😢";
    }
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

    if (happinessLevel > 100) happinessLevel = 100;
    if (happinessLevel < 0) happinessLevel = 0;
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;

      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
        if (happinessLevel < 0) happinessLevel = 0;
      }
    });
  }

  //  Called when countdown hits 0
  void _autoIncreaseHunger() {
    hungerLevel += 5;

    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel -= 20;
      if (happinessLevel < 0) happinessLevel = 0;
    }
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
    _countdownTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Enter pet name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _setPetName,
                child: Text("Set Name"),
              ),
              SizedBox(height: 20),

              Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 10),

              Text(
                'Mood: ${_moodStatus(happinessLevel)} ${_moodEmoji(happinessLevel)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              // Countdown display
              Text(
                'Next hunger increase in: $secondsUntilHungerTick s',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),

              SizedBox(height: 16),

              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _moodColor(happinessLevel),
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/pet_image.png',
                  height: 180,
                ),
              ),

              SizedBox(height: 16),

              Text('Happiness Level: $happinessLevel',
                  style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16),

              Text('Hunger Level: $hungerLevel',
                  style: TextStyle(fontSize: 20.0)),

              SizedBox(height: 32.0),

              ElevatedButton(
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              SizedBox(height: 16.0),

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
