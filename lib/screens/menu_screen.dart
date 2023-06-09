import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/apple_watch_screen.dart';
import 'package:flutter_animations/screens/balls_screen.dart';
import 'package:flutter_animations/screens/container_transform_screen.dart';
import 'package:flutter_animations/screens/explicit_animations_screen.dart';
import 'package:flutter_animations/screens/fade_through_screen.dart';
import 'package:flutter_animations/screens/implicit_animations_screen.dart';
import 'package:flutter_animations/screens/music_player_screen.dart';
import 'package:flutter_animations/screens/rating_screen.dart';
import 'package:flutter_animations/screens/rive_screen.dart';
import 'package:flutter_animations/screens/shared_axis_screen.dart';
import 'package:flutter_animations/screens/swiping_cards_screen.dart';
import 'package:flutter_animations/screens/wallet_screen.dart';
import 'package:flutter_animations/screens/wiggle_btn_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Animations',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ImplicitAnimationsScreen());
              },
              child: const Text(
                'Implicit Animations',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ExplicitAnimationsScreen());
              },
              child: const Text(
                'Explicit Animations',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const AppleWatchScreen());
              },
              child: const Text(
                'Apple Watch',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const SwipingCardsScreen());
              },
              child: const Text(
                'Swiping Cards',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const MusicPlaterScreen());
              },
              child: const Text(
                'Music Player',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const RiveScreen());
              },
              child: const Text(
                'Rive',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const RatingScreen());
              },
              child: const Text(
                'Rating',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const BallsScreen());
              },
              child: const Text(
                'Balls',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const WiggleBtnScreen());
              },
              child: const Text(
                'Wiggle Button',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ContainerTransformScreen());
              },
              child: const Text(
                'Container Transform',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const SharedAxisScreen());
              },
              child: const Text(
                'Shared Axis',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const FadeThroughScreen());
              },
              child: const Text(
                'Fade Through',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const WalletScreen());
              },
              child: const Text(
                'Wallet',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
