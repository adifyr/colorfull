import 'dart:math';

import 'package:flutter/painting.dart';

export 'src/colors/amber.dart';
export 'src/colors/aquamarine.dart';
export 'src/colors/black.dart';
export 'src/colors/blue.dart';
export 'src/colors/bright_green.dart';
export 'src/colors/brown.dart';
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
export 'src/colors/slate.dart';
export 'src/colors/sports_green.dart';
export 'src/colors/spring_green.dart';
export 'src/colors/violet.dart';
export 'src/colors/white.dart';
export 'src/colors/yellow.dart';
export 'src/swatch.dart';

extension ColorUtils on Color {
  static final _hsl = Expando<HSLColor>();

  /// Returns a new color with the specified [opacity].
  ///
  /// Valid values for [opacity] are in the range of 0.0-1.0.
  Color operator *(double opacity) {
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

  /// Returns a shade variant of this color based on the supplied [shade].
  ///
  /// The [shade] must be a multiple of 50 and in the range 50..950.
  Color operator [](int shade) {
    if (shade % 50 != 0) {
      throw Exception('Shade must be in range 50..950 and a multiple of 50.');
    }
    return (_hsl[this] ??= HSLColor.fromColor(
      this,
    )).withLightness(shade.clamp(50, 950) / 100).toColor();
  }

  /// 5% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter50 => _modifyLightness(0.05);

  /// 10% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter100 => _modifyLightness(0.10);

  /// 15% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter150 => _modifyLightness(0.15);

  /// 20% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter200 => _modifyLightness(0.20);

  /// 25% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter250 => _modifyLightness(0.25);

  /// 30% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter300 => _modifyLightness(0.30);

  /// 5% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker50 => _modifyLightness(-0.05);

  /// 10% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker100 => _modifyLightness(-0.10);

  /// 15% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker150 => _modifyLightness(-0.15);

  /// 20% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker200 => _modifyLightness(-0.20);

  /// 25% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker250 => _modifyLightness(-0.25);

  /// 30% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker300 => _modifyLightness(-0.30);

  /// Gets the contrasting shade of a color by adjusting its lightness by 60% either way.
  ///
  /// Useful for ensuring the readability of text placed on top of this color.
  Color get contrastColor {
    final hsl = _hsl[this] ??= HSLColor.fromColor(this);
    return switch (hsl.lightness) {
      > 0.6 => hsl.withLightness(max(hsl.lightness - 0.6, 0.0)),
      _ => hsl.withLightness(min(hsl.lightness + 0.6, 1.0)),
    }.toColor();
  }

  /// 5% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100%.
  Color get sat50 => _modifySaturation(0.05);

  /// 10% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100%.
  Color get sat100 => _modifySaturation(0.10);

  /// 15% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100%.
  Color get sat150 => _modifySaturation(0.15);

  /// 20% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100%.
  Color get sat200 => _modifySaturation(0.20);

  /// 25% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100%.
  Color get sat250 => _modifySaturation(0.25);

  /// 30% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100%.
  Color get sat300 => _modifySaturation(0.30);

  /// 5% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat50 => _modifySaturation(-0.05);

  /// 10% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat100 => _modifySaturation(-0.10);

  /// 15% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat150 => _modifySaturation(-0.15);

  /// 20% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat200 => _modifySaturation(-0.20);

  /// 25% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat250 => _modifySaturation(-0.25);

  /// 30% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat300 => _modifySaturation(-0.30);

  /// Disabled (70% Less Saturated) Variant of Original Color.
  ///
  /// Useful for the "disabled" state of a button or card.
  Color get disabledColor => _modifySaturation(-0.70);

  /// Modifies the lightness value of this color by the specified [light] amount.
  ///
  /// Positive values will make the color lighter, while negative values will make it darker.
  Color _modifyLightness(final double light) {
    final hsl = _hsl[this] ??= HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + light).clamp(0.0, 1.0)).toColor();
  }

  /// Modifies the saturation value of this color by the specified [sat] amount.
  ///
  /// Positive values will make the color more saturated, while negative values will make it less saturated.
  Color _modifySaturation(final double sat) {
    final hsl = _hsl[this] ??= HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation + sat).clamp(0.0, 1.0)).toColor();
  }
}
