import 'package:flutter/services.dart';

export 'colors/amber.dart';
export 'colors/aquamarine.dart';
export 'colors/blue.dart';
export 'colors/cornflower_blue.dart';
export 'colors/cyan.dart';
export 'colors/deep_blue.dart';
export 'colors/deep_orange.dart';
export 'colors/dodger_blue.dart';
export 'colors/forest_green.dart';
export 'colors/fuschia.dart';
export 'colors/green.dart';
export 'colors/grey.dart';
export 'colors/indigo.dart';
export 'colors/light_green.dart';
export 'colors/lime.dart';
export 'colors/lime_green.dart';
export 'colors/magenta.dart';
export 'colors/neon_green.dart';
export 'colors/orange.dart';
export 'colors/pink.dart';
export 'colors/pumpkin_orange.dart';
export 'colors/purple.dart';
export 'colors/red.dart';
export 'colors/rose.dart';
export 'colors/rose_red.dart';
export 'colors/royal_blue.dart';
export 'colors/sky_blue.dart';
export 'colors/sports_green.dart';
export 'colors/spring_green.dart';
export 'colors/violet.dart';
export 'colors/yellow.dart';

extension ColorUtils on Color {
  /// Returns a new color with the specified [opacity].
  ///
  /// Valid values for [opacity] are in the range of 0.0-1.0.
  Color operator *(final double opacity) {
    return withValues(alpha: opacity);
  }

  /// Returns the RGBA values for this color in the order: (red, green, blue, alpha).
  ///
  /// Values for RGBA will be in the range of 0-255. Example: ()
  (int, int, int, int) getRGBA() {
    return ((r * 255).round() & 0xff, (g * 255).round() & 0xff, (b * 255).round() & 0xff, (a * 255).round() & 0xff);
  }

  /// Returns the Hex Code [String] for this color. Example: #A38B29 (Amber H-600).
  ///
  /// If [includeHash] is true, the Hex Code will be prefixed by '#'. [includeHash] is true by default.
  String getHex([bool includeHash = true]) {
    return '${includeHash ? '#' : ''}${toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}
