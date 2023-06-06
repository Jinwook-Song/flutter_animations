import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class WiggleBtnScreen extends StatefulWidget {
  const WiggleBtnScreen({super.key});

  @override
  State<WiggleBtnScreen> createState() => WiggleBtnScreenState();
}

class WiggleBtnScreenState extends State<WiggleBtnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Wiggle Button',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF313131),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF313131),
            ),
            const RiveAnimation.asset(
              'assets/animations/wiggle_btn-rive.riv',
              stateMachines: ['state'],
            ),
            const Center(
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ));
  }
}
