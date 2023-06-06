import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  late final StateMachineController _stateMachineController;

  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: (stateMachineName, stateName) {
        print(stateName);
      },
    )!;
    artboard.addController(_stateMachineController);
  }

  @override
  void dispose() {
    _stateMachineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating'),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 500,
          child: RiveAnimation.asset(
            'assets/animations/rating-rive.riv',
            onInit: _onInit,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
