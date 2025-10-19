import 'dart:ui';

export 'src/colors/amber.dart';
export 'src/colors/aquamarine.dart';
export 'src/colors/black.dart';
export 'src/colors/blue.dart';
export 'src/colors/bright_green.dart';
export 'src/colors/cornflower_blue.dart';
export 'src/colors/cyan.dart';
export 'src/colors/deep_blue.dart';
export 'src/colors/deep_orange.dart';
export 'src/colors/dodger_blue.dart';
export 'src/colors/fuschia.dart';
export 'src/colors/green.dart';
export 'src/colors/grey.dart';
export 'src/colors/indigo.dart';
export 'src/colors/light_green.dart';
export 'src/colors/lime.dart';
export 'src/colors/lime_green.dart';
export 'src/colors/magenta.dart';
export 'src/colors/neon_green.dart';
export 'src/colors/orange.dart';
export 'src/colors/pink.dart';
export 'src/colors/pumpkin_orange.dart';
export 'src/colors/purple.dart';
export 'src/colors/red.dart';
export 'src/colors/rose.dart';
export 'src/colors/rose_red.dart';
export 'src/colors/royal_blue.dart';
export 'src/colors/sky_blue.dart';
export 'src/colors/sports_green.dart';
export 'src/colors/spring_green.dart';
export 'src/colors/violet.dart';
export 'src/colors/white.dart';
export 'src/colors/yellow.dart';
export 'src/swatch.dart';

extension ColorUtils on Color {
  /// Returns a new color with the specified [opacity].
  ///
  /// Valid values for [opacity] are in the range of 0.0-1.0.
  Color operator *(final double opacity) {
    return withValues(alpha: opacity);
  }

  /// Returns the RGBA values for this color in the order: (red, green, blue, alpha).
  ///
  /// RGBA values will be in the range of 0-255. Example: (242, 90, 120, 255)
  (int, int, int, int) getRGBA() {
    return (
      (r * 255).round() & 0xff,
      (g * 255).round() & 0xff,
      (b * 255).round() & 0xff,
      (a * 255).round() & 0xff,
    );
  }

  /// Returns the Hex Code [String] for this color. Example: #A38B29.
  ///
  /// If [includeHash] is 'true', the Hex Code will be prefixed by "#". [includeHash] is 'true' by default.
  String getHex([bool includeHash = true]) {
    return '${includeHash ? '#' : ''}${toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
