import 'package:flutter/material.dart';
import 'package:peace/screens/splashScreen.dart';

void main() {
  runApp(Peace());
}

class Peace extends StatelessWidget {
  const Peace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "Dongle",
          textTheme: TextTheme(
            subtitle1: TextStyle(fontSize: 28),
            caption: TextStyle(fontSize: 28),
            button: TextStyle(fontSize: 28),
            overline: TextStyle(fontSize: 28),
            subtitle2: TextStyle(fontSize: 28),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.blue.shade800),
      home: SplashScreen(), //SplashScreen
    );
  }
}
