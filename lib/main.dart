import 'dart:async'; // For timer

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // For sound

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReminderHomePage(),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({super.key});

  @override
  State<ReminderHomePage> createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  final List<String> activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep'
  ];

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String selectedDay = 'Monday';
  String selectedActivity = 'Wake up';
  TimeOfDay selectedTime = TimeOfDay.now();
  final AudioPlayer audioPlayer = AudioPlayer(); // For playing chime

  Timer? reminderTimer;

  void _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _setReminder() {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Adjust for past times
    if (selectedDateTime.isBefore(now)) {
      selectedDateTime.add(const Duration(days: 1));
    }

    final difference = selectedDateTime.difference(now).inSeconds;

    if (difference > 0) {
      // Cancel previous reminder if any
      reminderTimer?.cancel();
      // Set a new reminder
      reminderTimer = Timer(Duration(seconds: difference), _triggerReminder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for $selectedActivity at ${selectedTime.format(context)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected time has already passed.')),
      );
    }
  }

  void _triggerReminder() async {
    /*print('Reminder triggered for: $selectedActivity'); // Debug output
    try {
      // Play chime sound
      await audioPlayer.setAsset('assets/sound/chime.mp3'); // Set the audio asset
      await audioPlayer.play(); // Play the audio
    } catch (e) {
      print('Error playing audio: $e'); // Debug output for audio errors
    }*/

    // Show notification
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder!'),
        content: Text('It\'s time for $selectedActivity on $selectedDay'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    
     print('Reminder triggered for: $selectedActivity'); // Debug output
    try {
      // Play chime sound
      await audioPlayer.setAsset('assets/sound/chime.mp3'); // Set the audio asset
      await audioPlayer.play(); // Play the audio
    } catch (e) {
      print('Error playing audio: $e'); // Debug output for audio errors
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    reminderTimer?.cancel();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('⏰⏰Reminder App⏰⏰')),
        toolbarHeight:60,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Set your background image here
            fit: BoxFit.cover, // This will cover the entire screen
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Day of the Week:', style: TextStyle(color: Colors.black)), // Set text color
            DropdownButton<String>(
              value: selectedDay,
              items: days.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day, style: const TextStyle(color: Colors.black)), // Set text color
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Time:', style: TextStyle(color: Colors.black)), // Set text color
            TextButton(
              onPressed: () => _pickTime(context),
              child: Text(selectedTime.format(context), style: const TextStyle(color: Colors.black)), // Set text color
            ),
            const SizedBox(height: 16),
            const Text('Select Activity:', style: TextStyle(color: Colors.black)), // Set text color
            DropdownButton<String>(
              value: selectedActivity,
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity, style: const TextStyle(color: Colors.black)), // Set text color
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _setReminder,
                
                child: const Text('Set Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}























