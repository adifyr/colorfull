import 'package:colorfull/colorfull.dart';
import 'package:demo/components/item.dart' show ColorItem;
import 'package:demo/utils/globals.dart';
import 'package:flutter/material.dart';

class PaletteSection extends StatelessWidget {
  static const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final int idx;

  const PaletteSection(this.idx, {super.key});

  @override
  Widget build(BuildContext context) {
    final name = Colorfull.baseColors[idx];
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 64.0),
      children: [
        Text(
          Colorfull.baseColors[idx],
          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 40.0, letterSpacing: 0.0),
        ),
        const SizedBox(height: 32.0),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 20,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          children: [
            labelItem(SizedBox(), true),
            for (int a = 1; a < 20; a++) labelItem(Text("${a * 50}", style: TextStyle(fontSize: 12.0))),
            labelItem(Icon(Icons.circle, size: 8.0)),
            for (int b = 1; b < 20; b++)
              ColorItem(HSLColor.fromAHSL(1.0, idx * 12, 1.0, (20 - b) / 20).toColor(), name: '$name ${b * 50}'),
            for (int i = 1; i < 20; i++) ...[
              labelItem(Text(alphabet[i - 1], style: TextStyle(fontSize: 12.0))),
              for (int j = 1; j < 20; j++)
                ColorItem(
                  HSLColor.fromAHSL(1.0, idx * 12, (20 - i) / 20, (20 - j) / 20).toColor(),
                  name: '$name ${alphabet[i - 1]}-${j * 50}',
                ),
            ],
          ],
        ),
        const SizedBox(height: 48.0),
        if (name == 'Pumpkin Orange') ...[
          Text(
            'Brown',
            style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 40.0, letterSpacing: 0.0),
          ),
          const SizedBox(height: 32.0),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 20,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            children: [
              labelItem(SizedBox(), true),
              for (int i = 1; i < 20; i++) labelItem(Text('${i * 50}', style: TextStyle(fontSize: 12.0))),
              labelItem(Icon(Icons.circle, size: 8.0)),
              for (int j = 1; j < 20; j++)
                ColorItem(HSLColor.fromAHSL(1.0, idx * 12, 0.5, (20 - j) / 20).toColor(), name: 'Brown ${j * 50}'),
            ],
          ),
        ] else if (name == 'Cornflower Blue') ...[
          Text(
            'Slate',
            style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 40.0, letterSpacing: 0.0),
          ),
          const SizedBox(height: 32.0),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 20,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            children: [
              labelItem(SizedBox(), true),
              for (int i = 1; i < 20; i++) labelItem(Text('${i * 50}', style: TextStyle(fontSize: 12.0))),
              labelItem(Icon(Icons.circle, size: 8.0)),
              for (int j = 1; j < 20; j++)
                ColorItem(HSLColor.fromAHSL(1.0, idx * 12, 0.1, (20 - j) / 20).toColor(), name: 'Slate ${j * 50}'),
            ],
          ),
        ],
      ],
    );
  }

  Container labelItem(Widget label, [bool empty = false]) {
    return Container(
      decoration: empty
          ? null
          : ShapeDecoration(
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: white20, strokeAlign: BorderSide.strokeAlignOutside),
              ),
              color: cornflowerBlueR850,
            ),
      alignment: Alignment.center,
      child: label,
    );
  }
}
