import 'dart:math' show min, max;
import 'dart:ui' show Color;

/// A Color-based swatch for a base ARGB color.
///
/// `Swatch` extends [Color] and precomputes HSL-derived shades and saturation
/// grades for the base color. Use the provided getters (for select saturation
/// grades) or `[]` to access shades of the original color.
///
/// **Using a provided getter.**
///
/// ```dart
/// final swatch = Swatch(0xff6C35FF);
/// final lightVariant = swatch.b150; // 90% saturation, 85% lightness.
/// ```
///
/// **Using the `[]` operator to get a specific shade.**
/// ```dart
/// final swatch = Swatch(0xff6C35FF);
/// final lightVariant = swatch[150]; // Same saturation, 85% lightness.
/// ```
class Swatch extends Color {
  late final Map<int, Color> _colors;
  late final double _s, _l, _a;
  late double _h;

  /// Creates a [Swatch] from a 32-bit ARGB integer (0xAARRGGBB).
  ///
  /// The constructor extracts alpha, hue, saturation and lightness from `val`
  /// and precomputes the internal map of shade variants used by the getters
  /// and `operator []`.
  Swatch(final int val) : super(val) {
    _a = ((val >> 24) & 0xff) / 255;
    final red = ((val >> 16) & 0xff) / 255;
    final green = ((val >> 8) & 0xff) / 255;
    final blue = (val & 0xff) / 255;

    final mx = max(max(red, green), blue);
    final mn = min(min(red, green), blue);
    final delta = mx - mn;

    _h = switch (mx) {
      final v when v == mn => 0.0,
      final v when v == red => (green - blue) / delta,
      final v when v == green => ((blue - red) / delta) + 2.0,
      _ => ((red - green) / delta) + 4.0,
    };
    _h = _h * 60.0 + (_h < 0.0 ? 360.0 : 0.0);
    _l = (mx + mn) / 2;
    _s = mx == mn ? 0.0 : delta / (_l > 0.5 ? 2 - mx - mn : mx + mn);
    _colors = {
      for (int i = 5; i < 100; i += 5)
        i * 10: _hslToColor(_s, (100.0 - i) / 100.0),
    };
  }

  /// Returns the swatch color for the given [lightness] key.
  ///
  /// Valid lightness keys are 50, 100, 150, …, 950 (increments of 50).
  /// Throws a runtime exception if an invalid key is supplied.
  Color operator [](int lightness) => _colors[lightness]!;

  Color _hslToColor(double sat, double light) {
    assert(_h.isFinite && _h >= 0.0 && _h < 360.0);
    assert(sat >= 0.0 && sat <= 1.0);
    assert(light >= 0.0 && light <= 1.0);
    assert(_a >= 0.0 && _a <= 1.0);

    double hueToRgb(double p, double q, double t) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    }

    final q = light < 0.5 ? light * (1 + sat) : light + sat - light * sat;
    final p = 2 * light - q;
    final hk = _h / 360.0;
    final r = hueToRgb(p, q, hk + 1 / 3);
    final g = hueToRgb(p, q, hk);
    final b = hueToRgb(p, q, hk - 1 / 3);

    int toByte(double v) => ((v.clamp(0.0, 1.0) * 255).round()) & 0xFF;
    return Color(
      (toByte(_a) << 24) | (toByte(r) << 16) | (toByte(g) << 8) | toByte(b),
    );
  }

  /// 5% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter50 => _hslToColor(_s, max(1.0, _l + 0.05));

  /// 10% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter100 => _hslToColor(_s, max(1.0, _l + 0.1));

  /// 15% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter150 => _hslToColor(_s, max(1.0, _l + 0.15));

  /// 20% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter200 => _hslToColor(_s, max(1.0, _l + 0.2));

  /// 25% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter250 => _hslToColor(_s, max(1.0, _l + 0.25));

  /// 30% Lighter Variant of Original Color.
  ///
  /// Maximum Lightness is 100% (White).
  Color get lighter300 => _hslToColor(_s, max(1.0, _l + 0.3));

  /// 5% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker50 => _hslToColor(_s, min(0.0, _l - 0.05));

  /// 10% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker100 => _hslToColor(_s, min(0.0, _l - 0.1));

  /// 15% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker150 => _hslToColor(_s, min(0.0, _l - 0.15));

  /// 20% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker200 => _hslToColor(_s, min(0.0, _l - 0.2));

  /// 25% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker250 => _hslToColor(_s, min(0.0, _l - 0.25));

  /// 30% Darker Variant of Original Color.
  ///
  /// Minimum Lightness is 0% (Black).
  Color get darker300 => _hslToColor(_s, min(0.0, _l - 0.3));

  /// 5% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100% (Fully Saturated).
  Color get sat50 => _hslToColor(max(1.0, _s + 0.05), _l);

  /// 10% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100% (Fully Saturated).
  Color get sat100 => _hslToColor(max(1.0, _s + 0.1), _l);

  /// 15% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100% (Fully Saturated).
  Color get sat150 => _hslToColor(max(1.0, _s + 0.15), _l);

  /// 20% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100% (Fully Saturated).
  Color get sat200 => _hslToColor(max(1.0, _s + 0.2), _l);

  /// 25% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100% (Fully Saturated).
  Color get sat250 => _hslToColor(max(1.0, _s + 0.25), _l);

  /// 30% More Saturated Variant of Original Color.
  ///
  /// Maximum Saturation is 100% (Fully Saturated).
  Color get sat300 => _hslToColor(max(1.0, _s + 0.3), _l);

  /// 5% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat50 => _hslToColor(min(0.0, _s - 0.05), _l);

  /// 10% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat100 => _hslToColor(min(0.0, _s - 0.1), _l);

  /// 15% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat150 => _hslToColor(min(0.0, _s - 0.15), _l);

  /// 20% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat200 => _hslToColor(min(0.0, _s - 0.2), _l);

  /// 25% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat250 => _hslToColor(min(0.0, _s - 0.25), _l);

  /// 30% Less Saturated Variant of Original Color.
  ///
  /// Minimum Saturation is 0% (Grey).
  Color get desat300 => _hslToColor(min(0.0, _s - 0.3), _l);

  /// Swatch variant with Saturation Grade "A" (95% Saturation) and Original Lightness.
  Color get a0 => _hslToColor(0.95, _l);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 50 (95% Lightness).
  Color get a50 => _hslToColor(0.95, 0.95);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 100 (90% Lightness).
  Color get a100 => _hslToColor(0.95, 0.90);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 150 (85% Lightness).
  Color get a150 => _hslToColor(0.95, 0.85);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 200 (80% Lightness).
  Color get a200 => _hslToColor(0.95, 0.80);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 250 (75% Lightness).
  Color get a250 => _hslToColor(0.95, 0.75);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 300 (70% Lightness).
  Color get a300 => _hslToColor(0.95, 0.70);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 350 (65% Lightness).
  Color get a350 => _hslToColor(0.95, 0.65);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 400 (60% Lightness).
  Color get a400 => _hslToColor(0.95, 0.60);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 450 (55% Lightness).
  Color get a450 => _hslToColor(0.95, 0.55);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 500 (50% Lightness).
  Color get a500 => _hslToColor(0.95, 0.50);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 550 (45% Lightness).
  Color get a550 => _hslToColor(0.95, 0.45);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 600 (40% Lightness).
  Color get a600 => _hslToColor(0.95, 0.40);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 650 (35% Lightness).
  Color get a650 => _hslToColor(0.95, 0.35);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 700 (30% Lightness).
  Color get a700 => _hslToColor(0.95, 0.30);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 750 (25% Lightness).
  Color get a750 => _hslToColor(0.95, 0.25);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 800 (20% Lightness).
  Color get a800 => _hslToColor(0.95, 0.20);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 850 (15% Lightness).
  Color get a850 => _hslToColor(0.95, 0.15);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 900 (10% Lightness).
  Color get a900 => _hslToColor(0.95, 0.10);

  /// Swatch variant with Saturation Grade "A" (95% Saturation), Shade 950 (5% Lightness).
  Color get a950 => _hslToColor(0.95, 0.05);

  /// Swatch variant with Saturation Grade "B" (90% Saturation) and Original Lightness.
  Color get b0 => _hslToColor(0.90, _l);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 50 (95% Lightness).
  Color get b50 => _hslToColor(0.90, 0.95);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 100 (90% Lightness).
  Color get b100 => _hslToColor(0.90, 0.90);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 150 (85% Lightness).
  Color get b150 => _hslToColor(0.90, 0.85);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 200 (80% Lightness).
  Color get b200 => _hslToColor(0.90, 0.80);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 250 (75% Lightness).
  Color get b250 => _hslToColor(0.90, 0.75);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 300 (70% Lightness).
  Color get b300 => _hslToColor(0.90, 0.70);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 350 (65% Lightness).
  Color get b350 => _hslToColor(0.90, 0.65);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 400 (60% Lightness).
  Color get b400 => _hslToColor(0.90, 0.60);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 450 (55% Lightness).
  Color get b450 => _hslToColor(0.90, 0.55);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 500 (50% Lightness).
  Color get b500 => _hslToColor(0.90, 0.50);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 550 (45% Lightness).
  Color get b550 => _hslToColor(0.90, 0.45);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 600 (40% Lightness).
  Color get b600 => _hslToColor(0.90, 0.40);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 650 (35% Lightness).
  Color get b650 => _hslToColor(0.90, 0.35);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 700 (30% Lightness).
  Color get b700 => _hslToColor(0.90, 0.30);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 750 (25% Lightness).
  Color get b750 => _hslToColor(0.90, 0.25);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 800 (20% Lightness).
  Color get b800 => _hslToColor(0.90, 0.20);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 850 (15% Lightness).
  Color get b850 => _hslToColor(0.90, 0.15);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 900 (10% Lightness).
  Color get b900 => _hslToColor(0.90, 0.10);

  /// Swatch variant with Saturation Grade "B" (90% Saturation), Shade 950 (5% Lightness).
  Color get b950 => _hslToColor(0.90, 0.05);

  /// Swatch variant with Saturation Grade "C" (85% Saturation) and Original Lightness.
  Color get c0 => _hslToColor(0.85, _l);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 50 (95% Lightness).
  Color get c50 => _hslToColor(0.85, 0.95);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 100 (90% Lightness).
  Color get c100 => _hslToColor(0.85, 0.90);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 150 (85% Lightness).
  Color get c150 => _hslToColor(0.85, 0.85);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 200 (80% Lightness).
  Color get c200 => _hslToColor(0.85, 0.80);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 250 (75% Lightness).
  Color get c250 => _hslToColor(0.85, 0.75);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 300 (70% Lightness).
  Color get c300 => _hslToColor(0.85, 0.70);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 350 (65% Lightness).
  Color get c350 => _hslToColor(0.85, 0.65);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 400 (60% Lightness).
  Color get c400 => _hslToColor(0.85, 0.60);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 450 (55% Lightness).
  Color get c450 => _hslToColor(0.85, 0.55);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 500 (50% Lightness).
  Color get c500 => _hslToColor(0.85, 0.50);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 550 (45% Lightness).
  Color get c550 => _hslToColor(0.85, 0.45);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 600 (40% Lightness).
  Color get c600 => _hslToColor(0.85, 0.40);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 650 (35% Lightness).
  Color get c650 => _hslToColor(0.85, 0.35);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 700 (30% Lightness).
  Color get c700 => _hslToColor(0.85, 0.30);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 750 (25% Lightness).
  Color get c750 => _hslToColor(0.85, 0.25);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 800 (20% Lightness).
  Color get c800 => _hslToColor(0.85, 0.20);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 850 (15% Lightness).
  Color get c850 => _hslToColor(0.85, 0.15);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 900 (10% Lightness).
  Color get c900 => _hslToColor(0.85, 0.10);

  /// Swatch variant with Saturation Grade "C" (85% Saturation), Shade 950 (5% Lightness).
  Color get c950 => _hslToColor(0.85, 0.05);

  /// Swatch variant with Saturation Grade "D" (80% Saturation) and Original Lightness.
  Color get d0 => _hslToColor(0.80, _l);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 50 (95% Lightness).
  Color get d50 => _hslToColor(0.80, 0.95);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 100 (90% Lightness).
  Color get d100 => _hslToColor(0.80, 0.90);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 150 (85% Lightness).
  Color get d150 => _hslToColor(0.80, 0.85);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 200 (80% Lightness).
  Color get d200 => _hslToColor(0.80, 0.80);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 250 (75% Lightness).
  Color get d250 => _hslToColor(0.80, 0.75);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 300 (70% Lightness).
  Color get d300 => _hslToColor(0.80, 0.70);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 350 (65% Lightness).
  Color get d350 => _hslToColor(0.80, 0.65);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 400 (60% Lightness).
  Color get d400 => _hslToColor(0.80, 0.60);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 450 (55% Lightness).
  Color get d450 => _hslToColor(0.80, 0.55);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 500 (50% Lightness).
  Color get d500 => _hslToColor(0.80, 0.50);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 550 (45% Lightness).
  Color get d550 => _hslToColor(0.80, 0.45);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 600 (40% Lightness).
  Color get d600 => _hslToColor(0.80, 0.40);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 650 (35% Lightness).
  Color get d650 => _hslToColor(0.80, 0.35);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 700 (30% Lightness).
  Color get d700 => _hslToColor(0.80, 0.30);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 750 (25% Lightness).
  Color get d750 => _hslToColor(0.80, 0.25);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 800 (20% Lightness).
  Color get d800 => _hslToColor(0.80, 0.20);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 850 (15% Lightness).
  Color get d850 => _hslToColor(0.80, 0.15);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 900 (10% Lightness).
  Color get d900 => _hslToColor(0.80, 0.10);

  /// Swatch variant with Saturation Grade "D" (80% Saturation), Shade 950 (5% Lightness).
  Color get d950 => _hslToColor(0.80, 0.05);

  /// Swatch variant with Saturation Grade "E" (75% Saturation) and Original Lightness.
  Color get e0 => _hslToColor(0.75, _l);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 50 (95% Lightness).
  Color get e50 => _hslToColor(0.75, 0.95);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 100 (90% Lightness).
  Color get e100 => _hslToColor(0.75, 0.90);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 150 (85% Lightness).
  Color get e150 => _hslToColor(0.75, 0.85);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 200 (80% Lightness).
  Color get e200 => _hslToColor(0.75, 0.80);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 250 (75% Lightness).
  Color get e250 => _hslToColor(0.75, 0.75);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 300 (70% Lightness).
  Color get e300 => _hslToColor(0.75, 0.70);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 350 (65% Lightness).
  Color get e350 => _hslToColor(0.75, 0.65);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 400 (60% Lightness).
  Color get e400 => _hslToColor(0.75, 0.60);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 450 (55% Lightness).
  Color get e450 => _hslToColor(0.75, 0.55);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 500 (50% Lightness).
  Color get e500 => _hslToColor(0.75, 0.50);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 550 (45% Lightness).
  Color get e550 => _hslToColor(0.75, 0.45);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 600 (40% Lightness).
  Color get e600 => _hslToColor(0.75, 0.40);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 650 (35% Lightness).
  Color get e650 => _hslToColor(0.75, 0.35);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 700 (30% Lightness).
  Color get e700 => _hslToColor(0.75, 0.30);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 750 (25% Lightness).
  Color get e750 => _hslToColor(0.75, 0.25);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 800 (20% Lightness).
  Color get e800 => _hslToColor(0.75, 0.20);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 850 (15% Lightness).
  Color get e850 => _hslToColor(0.75, 0.15);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 900 (10% Lightness).
  Color get e900 => _hslToColor(0.75, 0.10);

  /// Swatch variant with Saturation Grade "E" (75% Saturation), Shade 950 (5% Lightness).
  Color get e950 => _hslToColor(0.75, 0.05);

  /// Swatch variant with Saturation Grade "F" (70% Saturation) and Original Lightness.
  Color get f0 => _hslToColor(0.70, _l);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 50 (95% Lightness).
  Color get f50 => _hslToColor(0.70, 0.95);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 100 (90% Lightness).
  Color get f100 => _hslToColor(0.70, 0.90);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 150 (85% Lightness).
  Color get f150 => _hslToColor(0.70, 0.85);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 200 (80% Lightness).
  Color get f200 => _hslToColor(0.70, 0.80);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 250 (75% Lightness).
  Color get f250 => _hslToColor(0.70, 0.75);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 300 (70% Lightness).
  Color get f300 => _hslToColor(0.70, 0.70);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 350 (65% Lightness).
  Color get f350 => _hslToColor(0.70, 0.65);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 400 (60% Lightness).
  Color get f400 => _hslToColor(0.70, 0.60);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 450 (55% Lightness).
  Color get f450 => _hslToColor(0.70, 0.55);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 500 (50% Lightness).
  Color get f500 => _hslToColor(0.70, 0.50);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 550 (45% Lightness).
  Color get f550 => _hslToColor(0.70, 0.45);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 600 (40% Lightness).
  Color get f600 => _hslToColor(0.70, 0.40);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 650 (35% Lightness).
  Color get f650 => _hslToColor(0.70, 0.35);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 700 (30% Lightness).
  Color get f700 => _hslToColor(0.70, 0.30);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 750 (25% Lightness).
  Color get f750 => _hslToColor(0.70, 0.25);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 800 (20% Lightness).
  Color get f800 => _hslToColor(0.70, 0.20);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 850 (15% Lightness).
  Color get f850 => _hslToColor(0.70, 0.15);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 900 (10% Lightness).
  Color get f900 => _hslToColor(0.70, 0.10);

  /// Swatch variant with Saturation Grade "F" (70% Saturation), Shade 950 (5% Lightness).
  Color get f950 => _hslToColor(0.70, 0.05);

  /// Swatch variant with Saturation Grade "G" (65% Saturation) and Original Lightness.
  Color get g0 => _hslToColor(0.65, _l);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 50 (95% Lightness).
  Color get g50 => _hslToColor(0.65, 0.95);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 100 (90% Lightness).
  Color get g100 => _hslToColor(0.65, 0.90);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 150 (85% Lightness).
  Color get g150 => _hslToColor(0.65, 0.85);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 200 (80% Lightness).
  Color get g200 => _hslToColor(0.65, 0.80);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 250 (75% Lightness).
  Color get g250 => _hslToColor(0.65, 0.75);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 300 (70% Lightness).
  Color get g300 => _hslToColor(0.65, 0.70);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 350 (65% Lightness).
  Color get g350 => _hslToColor(0.65, 0.65);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 400 (60% Lightness).
  Color get g400 => _hslToColor(0.65, 0.60);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 450 (55% Lightness).
  Color get g450 => _hslToColor(0.65, 0.55);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 500 (50% Lightness).
  Color get g500 => _hslToColor(0.65, 0.50);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 550 (45% Lightness).
  Color get g550 => _hslToColor(0.65, 0.45);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 600 (40% Lightness).
  Color get g600 => _hslToColor(0.65, 0.40);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 650 (35% Lightness).
  Color get g650 => _hslToColor(0.65, 0.35);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 700 (30% Lightness).
  Color get g700 => _hslToColor(0.65, 0.30);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 750 (25% Lightness).
  Color get g750 => _hslToColor(0.65, 0.25);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 800 (20% Lightness).
  Color get g800 => _hslToColor(0.65, 0.20);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 850 (15% Lightness).
  Color get g850 => _hslToColor(0.65, 0.15);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 900 (10% Lightness).
  Color get g900 => _hslToColor(0.65, 0.10);

  /// Swatch variant with Saturation Grade "G" (65% Saturation), Shade 950 (5% Lightness).
  Color get g950 => _hslToColor(0.65, 0.05);

  /// Swatch variant with Saturation Grade "H" (60% Saturation) and Original Lightness.
  Color get h0 => _hslToColor(0.60, _l);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 50 (95% Lightness).
  Color get h50 => _hslToColor(0.60, 0.95);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 100 (90% Lightness).
  Color get h100 => _hslToColor(0.60, 0.90);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 150 (85% Lightness).
  Color get h150 => _hslToColor(0.60, 0.85);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 200 (80% Lightness).
  Color get h200 => _hslToColor(0.60, 0.80);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 250 (75% Lightness).
  Color get h250 => _hslToColor(0.60, 0.75);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 300 (70% Lightness).
  Color get h300 => _hslToColor(0.60, 0.70);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 350 (65% Lightness).
  Color get h350 => _hslToColor(0.60, 0.65);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 400 (60% Lightness).
  Color get h400 => _hslToColor(0.60, 0.60);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 450 (55% Lightness).
  Color get h450 => _hslToColor(0.60, 0.55);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 500 (50% Lightness).
  Color get h500 => _hslToColor(0.60, 0.50);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 550 (45% Lightness).
  Color get h550 => _hslToColor(0.60, 0.45);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 600 (40% Lightness).
  Color get h600 => _hslToColor(0.60, 0.40);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 650 (35% Lightness).
  Color get h650 => _hslToColor(0.60, 0.35);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 700 (30% Lightness).
  Color get h700 => _hslToColor(0.60, 0.30);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 750 (25% Lightness).
  Color get h750 => _hslToColor(0.60, 0.25);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 800 (20% Lightness).
  Color get h800 => _hslToColor(0.60, 0.20);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 850 (15% Lightness).
  Color get h850 => _hslToColor(0.60, 0.15);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 900 (10% Lightness).
  Color get h900 => _hslToColor(0.60, 0.10);

  /// Swatch variant with Saturation Grade "H" (60% Saturation), Shade 950 (5% Lightness).
  Color get h950 => _hslToColor(0.60, 0.05);

  /// Swatch variant with Saturation Grade "I" (55% Saturation) and Original Lightness.
  Color get i0 => _hslToColor(0.55, _l);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 50 (95% Lightness).
  Color get i50 => _hslToColor(0.55, 0.95);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 100 (90% Lightness).
  Color get i100 => _hslToColor(0.55, 0.90);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 150 (85% Lightness).
  Color get i150 => _hslToColor(0.55, 0.85);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 200 (80% Lightness).
  Color get i200 => _hslToColor(0.55, 0.80);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 250 (75% Lightness).
  Color get i250 => _hslToColor(0.55, 0.75);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 300 (70% Lightness).
  Color get i300 => _hslToColor(0.55, 0.70);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 350 (65% Lightness).
  Color get i350 => _hslToColor(0.55, 0.65);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 400 (60% Lightness).
  Color get i400 => _hslToColor(0.55, 0.60);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 450 (55% Lightness).
  Color get i450 => _hslToColor(0.55, 0.55);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 500 (50% Lightness).
  Color get i500 => _hslToColor(0.55, 0.50);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 550 (45% Lightness).
  Color get i550 => _hslToColor(0.55, 0.45);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 600 (40% Lightness).
  Color get i600 => _hslToColor(0.55, 0.40);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 650 (35% Lightness).
  Color get i650 => _hslToColor(0.55, 0.35);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 700 (30% Lightness).
  Color get i700 => _hslToColor(0.55, 0.30);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 750 (25% Lightness).
  Color get i750 => _hslToColor(0.55, 0.25);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 800 (20% Lightness).
  Color get i800 => _hslToColor(0.55, 0.20);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 850 (15% Lightness).
  Color get i850 => _hslToColor(0.55, 0.15);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 900 (10% Lightness).
  Color get i900 => _hslToColor(0.55, 0.10);

  /// Swatch variant with Saturation Grade "I" (55% Saturation), Shade 950 (5% Lightness).
  Color get i950 => _hslToColor(0.55, 0.05);

  /// Swatch variant with Saturation Grade "J" (50% Saturation) and Original Lightness.
  Color get j0 => _hslToColor(0.50, _l);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 50 (95% Lightness).
  Color get j50 => _hslToColor(0.50, 0.95);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 100 (90% Lightness).
  Color get j100 => _hslToColor(0.50, 0.90);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 150 (85% Lightness).
  Color get j150 => _hslToColor(0.50, 0.85);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 200 (80% Lightness).
  Color get j200 => _hslToColor(0.50, 0.80);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 250 (75% Lightness).
  Color get j250 => _hslToColor(0.50, 0.75);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 300 (70% Lightness).
  Color get j300 => _hslToColor(0.50, 0.70);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 350 (65% Lightness).
  Color get j350 => _hslToColor(0.50, 0.65);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 400 (60% Lightness).
  Color get j400 => _hslToColor(0.50, 0.60);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 450 (55% Lightness).
  Color get j450 => _hslToColor(0.50, 0.55);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 500 (50% Lightness).
  Color get j500 => _hslToColor(0.50, 0.50);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 550 (45% Lightness).
  Color get j550 => _hslToColor(0.50, 0.45);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 600 (40% Lightness).
  Color get j600 => _hslToColor(0.50, 0.40);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 650 (35% Lightness).
  Color get j650 => _hslToColor(0.50, 0.35);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 700 (30% Lightness).
  Color get j700 => _hslToColor(0.50, 0.30);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 750 (25% Lightness).
  Color get j750 => _hslToColor(0.50, 0.25);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 800 (20% Lightness).
  Color get j800 => _hslToColor(0.50, 0.20);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 850 (15% Lightness).
  Color get j850 => _hslToColor(0.50, 0.15);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 900 (10% Lightness).
  Color get j900 => _hslToColor(0.50, 0.10);

  /// Swatch variant with Saturation Grade "J" (50% Saturation), Shade 950 (5% Lightness).
  Color get j950 => _hslToColor(0.50, 0.05);

  /// Swatch variant with Saturation Grade "K" (45% Saturation) and Original Lightness.
  Color get k0 => _hslToColor(0.45, _l);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 50 (95% Lightness).
  Color get k50 => _hslToColor(0.45, 0.95);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 100 (90% Lightness).
  Color get k100 => _hslToColor(0.45, 0.90);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 150 (85% Lightness).
  Color get k150 => _hslToColor(0.45, 0.85);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 200 (80% Lightness).
  Color get k200 => _hslToColor(0.45, 0.80);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 250 (75% Lightness).
  Color get k250 => _hslToColor(0.45, 0.75);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 300 (70% Lightness).
  Color get k300 => _hslToColor(0.45, 0.70);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 350 (65% Lightness).
  Color get k350 => _hslToColor(0.45, 0.65);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 400 (60% Lightness).
  Color get k400 => _hslToColor(0.45, 0.60);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 450 (55% Lightness).
  Color get k450 => _hslToColor(0.45, 0.55);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 500 (50% Lightness).
  Color get k500 => _hslToColor(0.45, 0.50);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 550 (45% Lightness).
  Color get k550 => _hslToColor(0.45, 0.45);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 600 (40% Lightness).
  Color get k600 => _hslToColor(0.45, 0.40);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 650 (35% Lightness).
  Color get k650 => _hslToColor(0.45, 0.35);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 700 (30% Lightness).
  Color get k700 => _hslToColor(0.45, 0.30);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 750 (25% Lightness).
  Color get k750 => _hslToColor(0.45, 0.25);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 800 (20% Lightness).
  Color get k800 => _hslToColor(0.45, 0.20);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 850 (15% Lightness).
  Color get k850 => _hslToColor(0.45, 0.15);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 900 (10% Lightness).
  Color get k900 => _hslToColor(0.45, 0.10);

  /// Swatch variant with Saturation Grade "K" (45% Saturation), Shade 950 (5% Lightness).
  Color get k950 => _hslToColor(0.45, 0.05);

  /// Swatch variant with Saturation Grade "L" (40% Saturation) and Original Lightness.
  Color get l0 => _hslToColor(0.40, _l);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 50 (95% Lightness).
  Color get l50 => _hslToColor(0.40, 0.95);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 100 (90% Lightness).
  Color get l100 => _hslToColor(0.40, 0.90);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 150 (85% Lightness).
  Color get l150 => _hslToColor(0.40, 0.85);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 200 (80% Lightness).
  Color get l200 => _hslToColor(0.40, 0.80);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 250 (75% Lightness).
  Color get l250 => _hslToColor(0.40, 0.75);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 300 (70% Lightness).
  Color get l300 => _hslToColor(0.40, 0.70);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 350 (65% Lightness).
  Color get l350 => _hslToColor(0.40, 0.65);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 400 (60% Lightness).
  Color get l400 => _hslToColor(0.40, 0.60);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 450 (55% Lightness).
  Color get l450 => _hslToColor(0.40, 0.55);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 500 (50% Lightness).
  Color get l500 => _hslToColor(0.40, 0.50);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 550 (45% Lightness).
  Color get l550 => _hslToColor(0.40, 0.45);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 600 (40% Lightness).
  Color get l600 => _hslToColor(0.40, 0.40);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 650 (35% Lightness).
  Color get l650 => _hslToColor(0.40, 0.35);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 700 (30% Lightness).
  Color get l700 => _hslToColor(0.40, 0.30);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 750 (25% Lightness).
  Color get l750 => _hslToColor(0.40, 0.25);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 800 (20% Lightness).
  Color get l800 => _hslToColor(0.40, 0.20);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 850 (15% Lightness).
  Color get l850 => _hslToColor(0.40, 0.15);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 900 (10% Lightness).
  Color get l900 => _hslToColor(0.40, 0.10);

  /// Swatch variant with Saturation Grade "L" (40% Saturation), Shade 950 (5% Lightness).
  Color get l950 => _hslToColor(0.40, 0.05);

  /// Swatch variant with Saturation Grade "M" (35% Saturation) and Original Lightness.
  Color get m0 => _hslToColor(0.35, _l);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 50 (95% Lightness).
  Color get m50 => _hslToColor(0.35, 0.95);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 100 (90% Lightness).
  Color get m100 => _hslToColor(0.35, 0.90);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 150 (85% Lightness).
  Color get m150 => _hslToColor(0.35, 0.85);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 200 (80% Lightness).
  Color get m200 => _hslToColor(0.35, 0.80);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 250 (75% Lightness).
  Color get m250 => _hslToColor(0.35, 0.75);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 300 (70% Lightness).
  Color get m300 => _hslToColor(0.35, 0.70);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 350 (65% Lightness).
  Color get m350 => _hslToColor(0.35, 0.65);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 400 (60% Lightness).
  Color get m400 => _hslToColor(0.35, 0.60);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 450 (55% Lightness).
  Color get m450 => _hslToColor(0.35, 0.55);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 500 (50% Lightness).
  Color get m500 => _hslToColor(0.35, 0.50);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 550 (45% Lightness).
  Color get m550 => _hslToColor(0.35, 0.45);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 600 (40% Lightness).
  Color get m600 => _hslToColor(0.35, 0.40);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 650 (35% Lightness).
  Color get m650 => _hslToColor(0.35, 0.35);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 700 (30% Lightness).
  Color get m700 => _hslToColor(0.35, 0.30);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 750 (25% Lightness).
  Color get m750 => _hslToColor(0.35, 0.25);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 800 (20% Lightness).
  Color get m800 => _hslToColor(0.35, 0.20);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 850 (15% Lightness).
  Color get m850 => _hslToColor(0.35, 0.15);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 900 (10% Lightness).
  Color get m900 => _hslToColor(0.35, 0.10);

  /// Swatch variant with Saturation Grade "M" (35% Saturation), Shade 950 (5% Lightness).
  Color get m950 => _hslToColor(0.35, 0.05);

  /// Swatch variant with Saturation Grade "N" (30% Saturation) and Original Lightness.
  Color get n0 => _hslToColor(0.30, _l);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 50 (95% Lightness).
  Color get n50 => _hslToColor(0.30, 0.95);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 100 (90% Lightness).
  Color get n100 => _hslToColor(0.30, 0.90);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 150 (85% Lightness).
  Color get n150 => _hslToColor(0.30, 0.85);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 200 (80% Lightness).
  Color get n200 => _hslToColor(0.30, 0.80);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 250 (75% Lightness).
  Color get n250 => _hslToColor(0.30, 0.75);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 300 (70% Lightness).
  Color get n300 => _hslToColor(0.30, 0.70);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 350 (65% Lightness).
  Color get n350 => _hslToColor(0.30, 0.65);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 400 (60% Lightness).
  Color get n400 => _hslToColor(0.30, 0.60);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 450 (55% Lightness).
  Color get n450 => _hslToColor(0.30, 0.55);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 500 (50% Lightness).
  Color get n500 => _hslToColor(0.30, 0.50);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 550 (45% Lightness).
  Color get n550 => _hslToColor(0.30, 0.45);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 600 (40% Lightness).
  Color get n600 => _hslToColor(0.30, 0.40);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 650 (35% Lightness).
  Color get n650 => _hslToColor(0.30, 0.35);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 700 (30% Lightness).
  Color get n700 => _hslToColor(0.30, 0.30);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 750 (25% Lightness).
  Color get n750 => _hslToColor(0.30, 0.25);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 800 (20% Lightness).
  Color get n800 => _hslToColor(0.30, 0.20);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 850 (15% Lightness).
  Color get n850 => _hslToColor(0.30, 0.15);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 900 (10% Lightness).
  Color get n900 => _hslToColor(0.30, 0.10);

  /// Swatch variant with Saturation Grade "N" (30% Saturation), Shade 950 (5% Lightness).
  Color get n950 => _hslToColor(0.30, 0.05);

  /// Swatch variant with Saturation Grade "O" (25% Saturation) and Original Lightness.
  Color get o0 => _hslToColor(0.25, _l);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 50 (95% Lightness).
  Color get o50 => _hslToColor(0.25, 0.95);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 100 (90% Lightness).
  Color get o100 => _hslToColor(0.25, 0.90);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 150 (85% Lightness).
  Color get o150 => _hslToColor(0.25, 0.85);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 200 (80% Lightness).
  Color get o200 => _hslToColor(0.25, 0.80);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 250 (75% Lightness).
  Color get o250 => _hslToColor(0.25, 0.75);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 300 (70% Lightness).
  Color get o300 => _hslToColor(0.25, 0.70);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 350 (65% Lightness).
  Color get o350 => _hslToColor(0.25, 0.65);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 400 (60% Lightness).
  Color get o400 => _hslToColor(0.25, 0.60);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 450 (55% Lightness).
  Color get o450 => _hslToColor(0.25, 0.55);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 500 (50% Lightness).
  Color get o500 => _hslToColor(0.25, 0.50);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 550 (45% Lightness).
  Color get o550 => _hslToColor(0.25, 0.45);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 600 (40% Lightness).
  Color get o600 => _hslToColor(0.25, 0.40);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 650 (35% Lightness).
  Color get o650 => _hslToColor(0.25, 0.35);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 700 (30% Lightness).
  Color get o700 => _hslToColor(0.25, 0.30);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 750 (25% Lightness).
  Color get o750 => _hslToColor(0.25, 0.25);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 800 (20% Lightness).
  Color get o800 => _hslToColor(0.25, 0.20);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 850 (15% Lightness).
  Color get o850 => _hslToColor(0.25, 0.15);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 900 (10% Lightness).
  Color get o900 => _hslToColor(0.25, 0.10);

  /// Swatch variant with Saturation Grade "O" (25% Saturation), Shade 950 (5% Lightness).
  Color get o950 => _hslToColor(0.25, 0.05);

  /// Swatch variant with Saturation Grade "P" (20% Saturation) and Original Lightness.
  Color get p0 => _hslToColor(0.20, _l);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 50 (95% Lightness).
  Color get p50 => _hslToColor(0.20, 0.95);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 100 (90% Lightness).
  Color get p100 => _hslToColor(0.20, 0.90);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 150 (85% Lightness).
  Color get p150 => _hslToColor(0.20, 0.85);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 200 (80% Lightness).
  Color get p200 => _hslToColor(0.20, 0.80);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 250 (75% Lightness).
  Color get p250 => _hslToColor(0.20, 0.75);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 300 (70% Lightness).
  Color get p300 => _hslToColor(0.20, 0.70);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 350 (65% Lightness).
  Color get p350 => _hslToColor(0.20, 0.65);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 400 (60% Lightness).
  Color get p400 => _hslToColor(0.20, 0.60);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 450 (55% Lightness).
  Color get p450 => _hslToColor(0.20, 0.55);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 500 (50% Lightness).
  Color get p500 => _hslToColor(0.20, 0.50);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 550 (45% Lightness).
  Color get p550 => _hslToColor(0.20, 0.45);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 600 (40% Lightness).
  Color get p600 => _hslToColor(0.20, 0.40);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 650 (35% Lightness).
  Color get p650 => _hslToColor(0.20, 0.35);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 700 (30% Lightness).
  Color get p700 => _hslToColor(0.20, 0.30);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 750 (25% Lightness).
  Color get p750 => _hslToColor(0.20, 0.25);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 800 (20% Lightness).
  Color get p800 => _hslToColor(0.20, 0.20);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 850 (15% Lightness).
  Color get p850 => _hslToColor(0.20, 0.15);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 900 (10% Lightness).
  Color get p900 => _hslToColor(0.20, 0.10);

  /// Swatch variant with Saturation Grade "P" (20% Saturation), Shade 950 (5% Lightness).
  Color get p950 => _hslToColor(0.20, 0.05);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 0 (100% Lightness).
  Color get q0 => _hslToColor(0.15, _l);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 50 (95% Lightness).
  Color get q50 => _hslToColor(0.15, 0.95);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 100 (90% Lightness).
  Color get q100 => _hslToColor(0.15, 0.90);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 150 (85% Lightness).
  Color get q150 => _hslToColor(0.15, 0.85);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 200 (80% Lightness).
  Color get q200 => _hslToColor(0.15, 0.80);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 250 (75% Lightness).
  Color get q250 => _hslToColor(0.15, 0.75);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 300 (70% Lightness).
  Color get q300 => _hslToColor(0.15, 0.70);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 350 (65% Lightness).
  Color get q350 => _hslToColor(0.15, 0.65);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 400 (60% Lightness).
  Color get q400 => _hslToColor(0.15, 0.60);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 450 (55% Lightness).
  Color get q450 => _hslToColor(0.15, 0.55);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 500 (50% Lightness).
  Color get q500 => _hslToColor(0.15, 0.50);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 550 (45% Lightness).
  Color get q550 => _hslToColor(0.15, 0.45);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 600 (40% Lightness).
  Color get q600 => _hslToColor(0.15, 0.40);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 650 (35% Lightness).
  Color get q650 => _hslToColor(0.15, 0.35);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 700 (30% Lightness).
  Color get q700 => _hslToColor(0.15, 0.30);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 750 (25% Lightness).
  Color get q750 => _hslToColor(0.15, 0.25);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 800 (20% Lightness).
  Color get q800 => _hslToColor(0.15, 0.20);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 850 (15% Lightness).
  Color get q850 => _hslToColor(0.15, 0.15);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 900 (10% Lightness).
  Color get q900 => _hslToColor(0.15, 0.10);

  /// Swatch variant with Saturation Grade "Q" (15% Saturation), Shade 950 (5% Lightness).
  Color get q950 => _hslToColor(0.15, 0.05);

  /// Swatch variant with Saturation Grade "R" (10% Saturation) and Original Lightness.
  Color get r0 => _hslToColor(0.10, 0.50);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 50 (95% Lightness).
  Color get r50 => _hslToColor(0.10, 0.95);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 100 (90% Lightness).
  Color get r100 => _hslToColor(0.10, 0.90);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 150 (85% Lightness).
  Color get r150 => _hslToColor(0.10, 0.85);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 200 (80% Lightness).
  Color get r200 => _hslToColor(0.10, 0.80);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 250 (75% Lightness).
  Color get r250 => _hslToColor(0.10, 0.75);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 300 (70% Lightness).
  Color get r300 => _hslToColor(0.10, 0.70);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 350 (65% Lightness).
  Color get r350 => _hslToColor(0.10, 0.65);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 400 (60% Lightness).
  Color get r400 => _hslToColor(0.10, 0.60);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 450 (55% Lightness).
  Color get r450 => _hslToColor(0.10, 0.55);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 500 (50% Lightness).
  Color get r500 => _hslToColor(0.10, 0.50);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 550 (45% Lightness).
  Color get r550 => _hslToColor(0.10, 0.45);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 600 (40% Lightness).
  Color get r600 => _hslToColor(0.10, 0.40);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 650 (35% Lightness).
  Color get r650 => _hslToColor(0.10, 0.35);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 700 (30% Lightness).
  Color get r700 => _hslToColor(0.10, 0.30);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 750 (25% Lightness).
  Color get r750 => _hslToColor(0.10, 0.25);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 800 (20% Lightness).
  Color get r800 => _hslToColor(0.10, 0.20);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 850 (15% Lightness).
  Color get r850 => _hslToColor(0.10, 0.15);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 900 (10% Lightness).
  Color get r900 => _hslToColor(0.10, 0.10);

  /// Swatch variant with Saturation Grade "R" (10% Saturation), Shade 950 (5% Lightness).
  Color get r950 => _hslToColor(0.10, 0.05);

  /// Swatch variant with Saturation Grade "S" (5% Saturation) and Original Lightness.
  Color get s0 => _hslToColor(0.05, 0.50);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 50 (95% Lightness).
  Color get s50 => _hslToColor(0.05, 0.95);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 100 (90% Lightness).
  Color get s100 => _hslToColor(0.05, 0.90);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 150 (85% Lightness).
  Color get s150 => _hslToColor(0.05, 0.85);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 200 (80% Lightness).
  Color get s200 => _hslToColor(0.05, 0.80);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 250 (75% Lightness).
  Color get s250 => _hslToColor(0.05, 0.75);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 300 (70% Lightness).
  Color get s300 => _hslToColor(0.05, 0.70);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 350 (65% Lightness).
  Color get s350 => _hslToColor(0.05, 0.65);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 400 (60% Lightness).
  Color get s400 => _hslToColor(0.05, 0.60);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 450 (55% Lightness).
  Color get s450 => _hslToColor(0.05, 0.55);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 500 (50% Lightness).
  Color get s500 => _hslToColor(0.05, 0.50);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 550 (45% Lightness).
  Color get s550 => _hslToColor(0.05, 0.45);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 600 (40% Lightness).
  Color get s600 => _hslToColor(0.05, 0.40);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 650 (35% Lightness).
  Color get s650 => _hslToColor(0.05, 0.35);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 700 (30% Lightness).
  Color get s700 => _hslToColor(0.05, 0.30);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 750 (25% Lightness).
  Color get s750 => _hslToColor(0.05, 0.25);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 800 (20% Lightness).
  Color get s800 => _hslToColor(0.05, 0.20);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 850 (15% Lightness).
  Color get s850 => _hslToColor(0.05, 0.15);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 900 (10% Lightness).
  Color get s900 => _hslToColor(0.05, 0.10);

  /// Swatch variant with Saturation Grade "S" (5% Saturation), Shade 950 (5% Lightness).
  Color get s950 => _hslToColor(0.05, 0.05);
}
