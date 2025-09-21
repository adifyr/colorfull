import 'dart:io';
import 'package:flutter/widgets.dart';

void main() {
  createColors();
  final file = File('lib/colors/grey.dart');
  file.writeAsStringSync("import 'package:flutter/services.dart';\n\n", mode: FileMode.writeOnlyAppend);
  file.writeAsStringSync('/// White. Hex Code: #FFFFFF.\n', mode: FileMode.writeOnlyAppend);
  file.writeAsStringSync('const white = Color(0xffFFFFFF);\n\n', mode: FileMode.writeOnlyAppend);
  for (int l = 5; l < 100; l += 5) {
    final color = HSLColor.fromAHSL(1.0, 0.0, 0.0, (100 - l) / 100).toColor();
    final hexCode = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
    file.writeAsStringSync('/// Grey ${l * 10}. Hex Code: #$hexCode.\n', mode: FileMode.writeOnlyAppend);
    file.writeAsStringSync('const grey${l * 10} = Color(0xff$hexCode);\n\n', mode: FileMode.writeOnlyAppend);
    if (l == 50) {
      file.writeAsStringSync(
        '/// Convenient shorthand for "Grey 500" - since it is the base color.\n',
        mode: FileMode.writeOnlyAppend,
      );
      file.writeAsStringSync('///\n/// Hex Code: #$hexCode.\n', mode: FileMode.writeOnlyAppend);
      file.writeAsStringSync('const grey = grey500;\n\n', mode: FileMode.writeOnlyAppend);
    }
  }
  for (int l = 5; l < 100; l += 5) {
    final color = HSLColor.fromAHSL(1.0, 0.0, 0.0, (100 - l) / 100).toColor();
    final hexCode = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
    file.writeAsStringSync('/// Gray ${l * 10}. Hex Code: #$hexCode.\n', mode: FileMode.writeOnlyAppend);
    file.writeAsStringSync('const gray${l * 10} = Color(0xff$hexCode);\n\n', mode: FileMode.writeOnlyAppend);
    if (l == 50) {
      file.writeAsStringSync(
        '/// Convenient shorthand for "Gray 500" - since it is the base color.\n///\n/// Hex Code: #$hexCode.\n',
        mode: FileMode.writeOnlyAppend,
      );
      file.writeAsStringSync('const gray = gray500;\n\n', mode: FileMode.writeOnlyAppend);
    }
  }
  file.writeAsStringSync('/// Black. Hex Code: #000000.\n', mode: FileMode.writeOnlyAppend);
  file.writeAsStringSync('const black = Color(0xff000000);\n', mode: FileMode.writeOnlyAppend);
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

const sats = ['', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S'];

void createColors() {
  for (int h = 0; h < colors.length; h++) {
    final directory = Directory('lib/colors');
    if (!directory.existsSync()) directory.createSync(recursive: true);
    final file = File('lib/colors/${colors[h]}.dart');
    file.writeAsStringSync("import 'package:flutter/services.dart';\n", mode: FileMode.writeOnlyAppend);
    final hue = toNameCase(colors[h]);
    final hueName = toNameCase(colors[h], separator: ' ');
    for (int s = 0; s < sats.length; s++) {
      for (int l = 5; l < 100; l += 5) {
        final color = HSLColor.fromAHSL(1.0, h * 12, (20 - s) / 20, (100 - l) / 100).toColor();
        final hexCode = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
        file.writeAsStringSync(
          '\n/// $hueName ${s > 0 ? '${sats[s]}-' : ''}${l * 10}. Hex Code: #$hexCode.\n',
          mode: FileMode.writeOnlyAppend,
        );
        file.writeAsStringSync(
          'const $hue${sats[s]}${l * 10} = Color(0xff$hexCode);\n',
          mode: FileMode.writeOnlyAppend,
        );
        if (s == 0 && l == 50) {
          file.writeAsStringSync(
            '\n/// Convenient shorthand for "$hueName 500" - since it is the base color.\n',
            mode: FileMode.writeOnlyAppend,
          );
          file.writeAsStringSync('///\n/// Hex Code: #$hexCode.\n', mode: FileMode.writeOnlyAppend);
          file.writeAsStringSync('const $hue = ${hue}500;\n', mode: FileMode.writeOnlyAppend);
        }
      }
    }
  }
}

void createExports() {
  final file = File('lib/exports.dart');
  for (final color in colors) {
    file.writeAsStringSync("export 'colors/$color.dart';\n", mode: FileMode.writeOnlyAppend);
  }
}

String toNameCase(String hue, {String separator = ''}) {
  if (separator.isEmpty) {
    final parts = hue.split('_');
    return '${parts.first}${parts.length < 2 ? '' : '${parts.last[0].toUpperCase()}${parts.last.substring(1)}'}';
  }
  return hue.splitMapJoin('_', onMatch: (_) => separator, onNonMatch: (p) => '${p[0].toUpperCase()}${p.substring(1)}');
}
