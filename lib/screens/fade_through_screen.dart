import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FadeThroughScreen extends StatefulWidget {
  const FadeThroughScreen({super.key});

  @override
  State<FadeThroughScreen> createState() => _FadeThroughScreenState();
}

class _FadeThroughScreenState extends State<FadeThroughScreen> {
  int _navIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fade Through'),
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: [
          const NavigationPage(
              key: ValueKey('Profile'), text: 'Profile', icon: Icons.person),
          const NavigationPage(
              key: ValueKey('Notifications'),
              text: 'Notifications',
              icon: Icons.notifications),
          const NavigationPage(
              key: ValueKey('Settings'),
              text: 'Settings',
              icon: Icons.settings),
        ][_navIndex],
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _navIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications),
              label: 'notifications',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'settings',
            ),
          ]),
    );
  }
}

class NavigationPage extends StatelessWidget {
  final String text;
  final IconData icon;
  const NavigationPage({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
