import 'package:colorfull/colorfull.dart';
import 'package:demo/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(primary: cornflowerBlueR700, secondary: sportsGreen550),
        scaffoldBackgroundColor: cornflowerBlueR900,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(letterSpacing: 0.0, color: white, fontSize: 20.0, fontWeight: FontWeight.w600),
          backgroundColor: black0,
          shape: Border(bottom: BorderSide(color: cornflowerBlueR800)),
        ),
      ),
      home: HomePage(),
    );
  }
}

Padding previewPadding(Widget child) {
  return Padding(padding: const EdgeInsets.all(16.0), child: child);
}
