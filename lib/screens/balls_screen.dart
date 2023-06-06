import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BallsScreen extends StatefulWidget {
  const BallsScreen({super.key});

  @override
  State<BallsScreen> createState() => BallsScreenState();
}

class BallsScreenState extends State<BallsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Balls'),
        ),
        body: Stack(
          children: [
            const RiveAnimation.asset(
              'assets/animations/balls-rive.riv',
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 50,
                  sigmaY: 50,
                ),
                child: const Center(
                  child: Text(
                    'Welcome to Animation',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
