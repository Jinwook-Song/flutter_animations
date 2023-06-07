import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Animations',
        theme: ThemeData(
          useMaterial3: true,
          navigationBarTheme: const NavigationBarThemeData(
            indicatorColor: Colors.amber,
          ),
          colorScheme: const ColorScheme.light(
            primary: Colors.pink,
          ),
        ),
        home: const MenuScreen());
  }
}
