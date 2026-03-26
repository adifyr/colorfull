---
name: colorfull
description: Explains what the colorfull Flutter package is and how to use it.
---

# Using the `colorfull` Flutter Package

## Overview

`colorfull` provides **11,041 named color constants** derived from the HSL color wheel: 29 base hues × 20 saturation levels × 19 lightness levels, plus 19 grey shades, black, and white. All colors are global Dart constants — no runtime computation, zero dependencies, fully tree-shakeable.

It also ships a `Swatch` class for generating a full HSL-based swatch from any single base color.

---

## Quick Reference

| Task | Approach |
|------|----------|
| Use a named color | `indigo650`, `redA400`, `cyanQ750` |
| Get hex string | `color.getHex()` → `'#A38B29'` |
| Get RGBA tuple | `color.getRGBA()` → `(r, g, b, a)` |
| Apply opacity | `color * 0.5` |
| Build swatch from brand color | `Swatch(0xFF0066CC)` |
| Access swatch variant | `swatch.a300`, `swatch.k650`, `swatch[900]` |
| Lighter/darker variant | `swatch.lighter100`, `swatch.darker150` |
| More/less saturated | `swatch.sat50`, `swatch.desat250` |

---

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  colorfull: ^<latest_version>
```

Then run:

```bash
flutter pub get
```

Import in any Dart file:

```dart
import 'package:colorfull/colorfull.dart';
```

---

## Color Naming Convention

Every color constant follows this pattern:

```
{baseName}{saturationLetter}{lightnessNumber}
```

### Base Hues (29 total)

`red`, `deepOrange`, `pumpkinOrange`, `orange`, `amber`, `yellow`, `lime`, `limeGreen`, `brightGreen`, `neonGreen`, `green`, `lightGreen`, `springGreen`, `sportsGreen`, `aquamarine`, `cyan`, `skyBlue`, `dodgerBlue`, `cornflowerBlue`, `royalBlue`, `blue`, `deepBlue`, `indigo`, `violet`, `purple`, `fuschia`, `magenta`, `pink`, `rose`

**Convenience aliases (single-saturation swatches):**
- `brown` → 50% saturation variant of Pumpkin Orange (`pumpkinOrangeJxx`)
- `slate` → 10% saturation variant of Cornflower Blue (`cornflowerBlueRxx`)

### Saturation Letters (A–S, high to low)

| Letter | Saturation |
|--------|-----------|
| A | 95% |
| B | 90% |
| C | 85% |
| D | 80% |
| E | 75% |
| F | 70% |
| G | 65% |
| H | 60% |
| I | 55% |
| J | 50% |
| K | 45% |
| L | 40% |
| M | 35% |
| N | 30% |
| O | 25% |
| P | 20% |
| Q | 15% |
| R | 10% |
| S | 5% |

### Lightness Numbers (50–950, light to dark)

`50`, `100`, `150`, `200`, `250`, `300`, `350`, `400`, `450`, `500`, `550`, `600`, `650`, `700`, `750`, `800`, `850`, `900`, `950`

### Examples

```dart
indigo650      // Indigo, 45% saturation, relatively dark
redA400        // Red, 95% saturation (very vivid), medium lightness
cyanQ750       // Cyan, 15% saturation (muted), dark
dodgerBlueA300 // Dodger Blue, 95% saturation, light
amberH600      // Amber, 60% saturation, darkish-medium
white          // Pure white
black          // Pure black
grey300        // Light grey (one of 19 grey shades)
```

---

## Using Color Constants

```dart
import 'package:colorfull/colorfull.dart';

// In a widget
Container(
  color: indigo650,
  padding: const EdgeInsets.all(16.0),
  child: Text(
    'Hello Colorfull!',
    style: TextStyle(color: white),
  ),
);

// In a ThemeData
ThemeData(
  colorScheme: ColorScheme(
    primary: royalBlueA400,
    secondary: amberH500,
    surface: grey100,
    onPrimary: white,
    onSecondary: black,
    onSurface: grey900,
    error: redA400,
    onError: white,
    brightness: Brightness.light,
  ),
);
```

---

## Color Extension Methods

All `colorfull` colors expose three extension methods:

```dart
// 1. Get RGBA components as a named tuple
final rgba = redK400.getRGBA();
// Returns: (r: 199, g: 107, b: 107, a: 255)

// 2. Get hex string
final hex = amberH600.getHex();
// Returns: '#A38B29'

// 3. Apply fractional opacity via * operator
final faded = blueP350 * 0.5;
// Returns: Color (Blue P-350) at 50% opacity
```

---

## Custom Swatches with `Swatch`

Use `Swatch` when you have a single brand/base color and want to derive a full, consistent HSL-based palette from it.

`Swatch` extends Flutter's `Color`, so it can be used anywhere a `Color` is accepted.

### Creating a Swatch

```dart
// From a literal ARGB int
final brand = Swatch(0xFF0066CC);

// From an existing colorfull constant
final brand = Swatch(royalBlueA400.toARGB32());

// From any Flutter Color
final brand = Swatch(myColor.toARGB32());
```

### Accessing Swatch Variants

```dart
// By saturation + lightness (letter + number getters)
brand.a200   // High saturation, light variant
brand.k650   // Medium saturation, dark variant

// By lightness only (preserves original saturation), using [] operator
brand[300]   // Light
brand[900]   // Dark

// Relative lightness adjustments
brand.lighter100  // 10% higher lightness
brand.lighter250  // 25% higher lightness
brand.darker100   // 10% lower lightness
brand.darker300   // 30% lower lightness

// Relative saturation adjustments
brand.sat50       // 5% more saturated
brand.desat150    // 15% less saturated
```

### Full Swatch Usage Example

```dart
final brand = Swatch(0xFF0066CC);

Container(
  decoration: BoxDecoration(
    color: brand.a200,                          // Vivid, light fill
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: brand.darker150, width: 2.0), // Darker border
  ),
  padding: const EdgeInsets.all(12),
  child: Text(
    'Brand',
    style: TextStyle(color: brand[900]),        // Dark text
  ),
);
```

---

## Tips

- **Autocompletion is your friend.** Type a base hue name (e.g. `indigo`) and let your IDE autocomplete through the available saturation/lightness combinations.
- **Tree shaking works automatically.** Only the color constants you reference will be included in the final build. No bundle-size penalty for having 11,041 constants available.
- **Keep saturation consistent** across your palette for a harmonious design system. Pick a saturation letter (e.g. `G` = 65%) and vary only lightness for a clean, coherent theme.
- **For neutral tones**, prefer `grey`, `slate`, or low-saturation variants (letters `Q`–`S`) of your primary hue.
- **Full API reference** (all constants listed): https://pub.dev/documentation/colorfull/latest
- **Live color demo**: https://demos-hosting.web.app/
