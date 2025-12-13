import 'package:collection/collection.dart';
import 'package:colorfull/colorfull.dart';
import 'package:demo/utils/globals.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  final void Function(int idx) onSelected;

  const HomeDrawer(this.onSelected, {super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  int selectedIdx = 0;
  int? hoverIdx;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0,
      decoration: BoxDecoration(
        border: BorderDirectional(end: BorderSide(color: cornflowerBlueR850)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
        children: [
          Text(
            'Colorfull Swatches',
            style: TextStyle(fontSize: 24.0, color: dodgerBlueC350, height: 1.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24.0),
          ...Colorfull.baseColors.mapIndexed((idx, colorName) {
            final color = HSLColor.fromAHSL(1.0, idx * 12, 1.0, 0.5).toColor();
            final name = switch (colorName) {
              'Pumpkin Orange' => 'Pumpkin Orange & Brown',
              'Cornflower Blue' => 'Cornflower Blue & Slate',
              _ => colorName,
            };
            return ListTile(
              title: Text(name, style: TextStyle(color: cornflowerBlueR200, fontSize: 14.0)),
              selected: idx == selectedIdx,
              leading: Icon(Icons.circle, color: color, size: 16.0),
              onTap: idx == selectedIdx ? null : () => onItemSelected(idx),
              selectedTileColor: white5,
              hoverColor: white10,
              splashColor: color * 0.1,
              shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(8.0)),
            );
          }),
        ],
      ),
    );
  }

  void onItemSelected(int idx) {
    widget.onSelected(idx);
    setState(() => selectedIdx = idx);
  }
}
