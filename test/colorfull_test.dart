import 'dart:io';
import 'package:flutter/widgets.dart';

void main() {
  createExports();
}

const colors = [
  'red', // 0
  'deep_orange', // 12
  'pumpkin_orange', // 24
  'orange', // 36
  'amber', // 48
  'yellow', // 60
  'lime', // 72
  'lime_green', // 84
  'forest_green', // 96
  'neon_green', // 108
  'green', // 120
  'light_green', // 132
  'spring_green', // 144
  'sports_green', // 156
  'aquamarine', // 168
  'cyan', // 180
  'sky_blue', // 192
  'dodger_blue', // 204
  'cornflower_blue', // 216
  'royal_blue', // 228
  'blue', // 240
  'deep_blue', // 252
  'indigo', // 264
  'violet', // 276
  'purple', // 288
  'fuschia', // 300
  'magenta', // 312
  'pink', // 324
  'rose', // 336
  'rose_red', // 348
];

const sats = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', ''];

void createColors() {
  for (int h = 0; h < colors.length; h++) {
    final directory = Directory('lib/colors');
    if (!directory.existsSync()) directory.createSync(recursive: true);
    final file = File('lib/colors/${colors[h]}.dart');
    file.writeAsStringSync("import 'package:flutter/services.dart';\n\n", mode: FileMode.writeOnlyAppend);
    final hue = toCamelCase(colors[h]);
    for (int s = 0; s < sats.length; s++) {
      for (int l = 5; l < 100; l += 5) {
        final sat = double.parse((s / 20 + 0.05).toStringAsFixed(2));
        final color = HSLColor.fromAHSL(1.0, h * 12, sat, (100 - l) / 100).toColor();
        final hexCode = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
        file.writeAsStringSync(
          'const $hue${sats[s]}${l * 10} = Color(0xff$hexCode);\n',
          mode: FileMode.writeOnlyAppend,
        );
        if (s == 19 && l == 50) file.writeAsStringSync('const $hue = $hue${l * 10};\n', mode: FileMode.writeOnlyAppend);
      }
      file.writeAsStringSync('\n', mode: FileMode.writeOnlyAppend);
    }
  }
}

void createExports() {
  final file = File('lib/exports.dart');
  for (final color in colors) {
    file.writeAsStringSync("export 'colors/$color.dart';\n", mode: FileMode.writeOnlyAppend);
  }
}

String toCamelCase(String text) {
  final parts = text.split('_');
  if (parts.length < 2) return text;
  return '${parts.first}${parts.last[0].toUpperCase()}${parts.last.substring(1)}';
}
