import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:search_app/home.dart';
import 'package:search_app/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: AnimatedSplashScreen(
            splash: Container(
              width: 500, // Adjust the width as needed
              height: 500, // Adjust the height as needed
              child: Image.asset('images/icons8-github-500.png'),
            ),
            duration: 1000,
            splashTransition: SplashTransition.rotationTransition,
            nextScreen: HomePage()));
  }
}
