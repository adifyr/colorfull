import 'package:colorfull/colorfull.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorItem extends StatelessWidget {
  final Color color;
  final String name;

  const ColorItem(this.color, {required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    final hex = color.getHex();
    return Tooltip(
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(8.0)),
        color: cornflowerBlueR800,
      ),
      textStyle: const TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontSize: 12.0,
        letterSpacing: 0.1,
        height: 1.6,
      ),
      textAlign: TextAlign.center,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      message: "$name\n${color.getHex()}",
      child: Material(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: white20, strokeAlign: BorderSide.strokeAlignOutside),
        ),
        color: color,
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: hex));
            final snackbar = SnackBar(
              content: Text(
                'Successfully copied Hex Code of Color $name to clipboard.',
                style: TextStyle(color: white),
              ),
              backgroundColor: cornflowerBlueR800,
              duration: Duration(seconds: 3),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          },
        ),
      ),
    );
  }
}
