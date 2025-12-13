import 'package:demo/components/home_drawer.dart';
import 'package:demo/components/palette.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeDrawer((idx) => setState(() => selectedIdx = idx)),
          Expanded(child: PaletteSection(selectedIdx)),
        ],
      ),
    );
  }
}
