
import 'dart:async';
import 'package:flutter/material.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds before opening the home screen.
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.event_note,
              size: 80,
              color: Colors.indigo,
            ),
            SizedBox(height: 20),
            Text(
              'Campus Activity Log',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Keep track of your campus activities',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
