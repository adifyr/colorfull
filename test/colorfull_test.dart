import 'dart:io';

import 'package:flutter/widgets.dart';

const colors = [
  'Red', // 0
  'Deep Orange', // 12
  'Pumpkin Orange', // 24
  'Orange', // 36
  'Amber', // 48
  'Yellow', // 60
  'Lime', // 72
  'Lime Green', // 84
  'Bright Green', // 96
  'Neon Green', // 108
  'Green', // 120
  'Light Green', // 132
  'Spring Green', // 144
  'Sports Green', // 156
  'Aquamarine', // 168
  'Cyan', // 180
  'Sky Blue', // 192
  'Dodger Blue', // 204
  'Cornflower Blue', // 216
  'Royal Blue', // 228
  'Blue', // 240
  'Deep Blue', // 252
  'Indigo', // 264
  'Violet', // 276
  'Purple', // 288
  'Fuschia', // 300
  'Magenta', // 312
  'Pink', // 324
  'Rose', // 336
  'Rose Red', // 348
];

const sats = ['', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S'];
const mode = FileMode.writeOnlyAppend;

void main() {
  for (int h = 0; h < colors.length; h++) {
    final name = colors[h];
    final file = File('lib/colors/${name.toLowerCase().replaceAll(' ', '_')}.dart');
    file.writeAsStringSync("import 'package:flutter/services.dart';\n", mode: mode);
    final varName = '${name[0].toLowerCase()}${name.substring(1).replaceAll(' ', '')}';
    for (int s = 0; s < sats.length; s++) {
      writeColorToFile(file, h, s, name, varName);
    }
  }
  final greyFile = File('lib/colors/grey.dart');
  greyFile.writeAsStringSync("import 'package:flutter/services.dart';\n", mode: mode);
  writeColorToFile(greyFile, 0, 20, 'Grey', 'grey');
  writeColorToFile(greyFile, 0, 20, 'Gray', 'gray');

  final whiteFile = File('lib/colors/white.dart');
  whiteFile.writeAsStringSync("import 'package:flutter/services.dart';\n", mode: mode);

  final blackFile = File('lib/colors/black.dart');
  blackFile.writeAsStringSync("import 'package:flutter/services.dart';\n", mode: mode);
  for (int a = 5; a < 100; a += 5) {
    final whiteAlpha = Color.fromRGBO(
      255,
      255,
      255,
      a / 100,
    ).toARGB32().toRadixString(16).padLeft(8, '0').substring(0, 2);
    whiteFile.writeAsStringSync('\n/// White - $a% Opacity.\n', mode: mode);
    whiteFile.writeAsStringSync('const white$a = Color(0x${whiteAlpha}FFFFFF);\n', mode: mode);

    final blackAlpha = Color.fromRGBO(0, 0, 0, a / 100).toARGB32().toRadixString(16).padLeft(8, '0').substring(0, 2);
    blackFile.writeAsStringSync('\n/// Black - $a% Opacity.\n', mode: mode);
    blackFile.writeAsStringSync('const black$a = Color(0x${blackAlpha}000000);\n', mode: mode);
  }
  whiteFile.writeAsStringSync('\n/// White. Hex Code: #FFFFFF.\nconst white = Color(0xffFFFFFF);\n', mode: mode);
  blackFile.writeAsStringSync('\n/// Black. Hex Code: #000000.\nconst black = Color(0xff000000);\n', mode: mode);
}

void writeColorToFile(File file, int h, int s, String name, String varName) {
  for (int l = 5; l < 100; l += 5) {
    final color = HSLColor.fromAHSL(1, h * 12, (20 - s) / 20, (100 - l) / 100).toColor();
    final hex = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
    final sat = s == 20 ? '' : sats[s];
    file.writeAsStringSync('\n/// $name ${sat.isEmpty ? '' : '$sat-'}${l * 10}. Hex Code: #$hex.\n', mode: mode);
    file.writeAsStringSync('const $varName$sat${l * 10} = Color(0xff$hex);\n', mode: mode);
    if (s == 0 && l == 50) {
      file.writeAsStringSync('\n/// Shorthand for [$varName$sat${l * 10}], since it is the base color.\n', mode: mode);
      file.writeAsStringSync('///\n/// Hex Code: #$hex.\n', mode: mode);
      file.writeAsStringSync('const $varName = $varName${l * 10};\n', mode: mode);
    }
  }
}
