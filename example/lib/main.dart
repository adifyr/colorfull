import 'package:colorfull/colorfull.dart'
    show grey50, indigo650, white85, dodgerBlueA250, dodgerBlueA900, deepOrangeC550;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: grey50,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: indigo650),
                child: Text(
                  'Hello Colorfull!',
                  style: TextStyle(fontWeight: FontWeight.w500, color: white85),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deep Orange - Hex: ${deepOrangeC550.getHex()} | RGBA: ${deepOrangeC550.getRGBA()} | Faded: ${deepOrangeC550 * 0.4}',
                      ),
                      backgroundColor: deepOrangeC550,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: dodgerBlueA250),
                child: Text('Dodger Blue', style: TextStyle(color: dodgerBlueA900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
