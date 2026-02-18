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

  // Mood text
  String _moodStatus(int happinessLevel) {
    if (happinessLevel > 70) {
      return "Happy";
    } else if (happinessLevel >= 30) {
      return "Neutral";
    } else {
      return "Unhappy";
    }
  }

  // Mood emoji
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),

            SizedBox(height: 10),

            // Mood text + emoji together
            Text(
              'Mood: ${_moodStatus(happinessLevel)} ${_moodEmoji(happinessLevel)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            // Pet image with color filter
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

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
