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

  //  Energy state
  int energyLevel = 70;

  final TextEditingController _nameController = TextEditingController();
  Timer? _timer;

  // Testing speed (set back to 30 later)
  int secondsUntilHungerTick = 10;

  // Win/Loss tracking (set win back to 180 later)
  int happySeconds = 0;
  bool gameEnded = false;

  int _clamp(int v) => v.clamp(0, 100);

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (gameEnded) return;

      setState(() {
        secondsUntilHungerTick--;

        if (secondsUntilHungerTick <= 0) {
          _autoIncreaseHunger();
          secondsUntilHungerTick = 10;
        }

        // Win condition (sped up for testing)
        if (happinessLevel > 80) {
          happySeconds++;
          if (happySeconds >= 30) {
            _showDialog("YOU WIN 🎉", "Your pet stayed happy long enough!");
          }
        } else {
          happySeconds = 0;
        }

        // Loss condition
        if (hungerLevel >= 100 && happinessLevel <= 10) {
          _showDialog("GAME OVER", "Your pet became too hungry and sad.");
        }
      });
    });
  }

  void _showDialog(String title, String message) {
    if (gameEnded) return;
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
      petName = "Your Pet";
      happinessLevel = 50;
      hungerLevel = 50;
      energyLevel = 70;

      secondsUntilHungerTick = 10;
      happySeconds = 0;
      gameEnded = false;
      _nameController.clear();
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

  // Energy logic: play costs energy, feeding restores a bit
  void _playWithPet() {
    setState(() {
      happinessLevel = _clamp(happinessLevel + 10);

      // play increases hunger a bit too (optional but makes sense)
      hungerLevel = _clamp(hungerLevel + 5);

      // energy decreases
      energyLevel = _clamp(energyLevel - 10);
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = _clamp(hungerLevel - 10);

      // feeding affects happiness based on hunger level
      if (hungerLevel < 30) {
        happinessLevel = _clamp(happinessLevel - 20);
      } else {
        happinessLevel = _clamp(happinessLevel + 10);
      }

      // energy increases a bit
      energyLevel = _clamp(energyLevel + 5);
    });
  }

  void _autoIncreaseHunger() {
    hungerLevel = _clamp(hungerLevel + 5);

    // if hunger maxes, happiness penalty
    if (hungerLevel == 100) {
      happinessLevel = _clamp(happinessLevel - 20);
    }

    // optional: small energy recovery over time
    energyLevel = _clamp(energyLevel + 1);
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

              // Small energy bar under the dog (now it moves)
              SizedBox(height: 6),
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  value: energyLevel / 100,
                  minHeight: 6,
                ),
              ),
              SizedBox(height: 16),

              Text('Happiness Level: $happinessLevel',
                  style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16),

              Text('Hunger Level: $hungerLevel',
                  style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 8),

              Text('Energy Level: $energyLevel',
                  style: TextStyle(fontSize: 18.0)),

              SizedBox(height: 12.0),

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
