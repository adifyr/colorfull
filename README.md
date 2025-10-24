<p align="center"><img src="https://raw.githubusercontent.com/adifyr/colorfull/refs/heads/main/assets/logo.png" height="120"></p>

# Colorfull

**Colorfull** was created to solve a major limitation in popular design systems like Tailwind and Material Design: their woefully limited color palettes. There is no quick and easy way to access a large range of colors directly, making it difficult to build themes and design systems with true creative freedom.

Colorfull solves this by giving Flutter developers direct, instant access to the full palette of 11,421 colors derived from the HSL color wheel — covering 30 base hues × 20 saturation levels × 19 lightness levels + 19 shades of grey + black and white. Every color is exposed as a global constant for fast, type-safe access — making it easy to build beautiful, consistent UIs with complete flexibility.

<p align="center"><img src="https://raw.githubusercontent.com/adifyr/colorfull/refs/heads/main/assets/system.png"></p>

## Features

- 🌈 **11,421 Colors**: Every possible combination of 30 base hues, 20 saturation levels, and 19 lightness levels + 19 shades of grey + black and white.
- 🔎 **Global Constants**: All colors are available as named Dart constants — no need to calculate or convert.
- 🎨 **Consistent Naming**: Colors are organized and named for easy lookup and autocompletion.
- ⚡️ **Zero Dependencies**: Pure Dart/Flutter, no external dependencies.
- 🖼️ **Perfect for Design Systems**: Build beautiful, consistent UIs with fine-grained color control.
- 🌳 **Highly Tree-Shakeable**: Only the colors you use are included in your final app build, keeping your app size minimal.
- ✏️ **Custom Swatches**: With our new `Swatch` class, you can now define custom swatches of your own!

## Usage

### Color Palette

Import the package and use any color constant.

```dart
import 'package:colorfull/colorfull.dart';

// Example: Use a vivid indigo color
Container(
  color: indigo650, // Or any other color constant
  padding: const EdgeInsets.all(16.0),
  child: Text('Hello Colorfull!', style: TextStyle(color: white)),
);

// Example: Use a specific hue, saturation, and lightness
Text('Dodger Blue A-300', style: TextStyle(color: dodgerBlueA300));
```

All colors are available as constants like `limeGreen`, `pumpkinOrange150`, `redA400`, `cyanQ750`, etc. See the API reference on [pub.dev](https://pub.dev/documentation/colorfull/latest) for the full list.

### Color Extensions

The library also provides helpful extensions for working with colors:

```dart
// Use the ColorUtils extension methods:
final rgba = redK400.getRGBA(); // (r: 199, g: 107, b: 107, a: 255) Tuple
final hex = amberH600.getHex(); // '#A38B29' String
final faded = blueP350 * 0.5;   // Color (Blue P-350) with 50% opacity
```

### Custom Swatches

You can now create your very own swatch from any base color using the `Swatch` class!

`Swatch` extends Flutter's `Color` and accepts a 32-bit ARGB integer (the same value you pass to `Color`).
From that base color the class generates a full HSL-based swatch: multiple saturation grades (A to S) and lightness shades (50 to 950).

- Create a swatch from an ARGB `int` or from an existing `Color` using `color.value`.
- Access generated variants using the letter/number getters (for example `a300`, `k650`) or by shade map (if you just want to adjust the lightness) with the `[]` operator (for example `swatch[300]`).
- Because `Swatch` extends `Color`, you can use it anywhere a `Color` is accepted.

Example:

```dart
import 'package:colorfull/colorfull.dart';

// Create a swatch from a literal ARGB value
final brand = Swatch(0xFF0066CC);

// Or create from an existing Color
// final brand = Swatch(blue650.value);

Container(
  color: brand.a200, // high-saturation, high-lightness variant
  padding: const EdgeInsets.all(12),
  child: Text('Brand', style: TextStyle(color: brand[900])),
);
```

The `Swatch` class is deterministic and HSL-based, so the variants it generates are consistent with the rest of the package's palette. Use it when you want to derive a full, consistent color system from a single brand or base color.

## How The System Works

### List Of 30 Base Colors/Hues

- `red`
- `deepOrange`
- `pumpkinOrange`
- `orange`
- `amber`
- `yellow`
- `lime`
- `limeGreen`
- `brightGreen`
- `neonGreen`
- `green`
- `lightGreen`
- `sportsGreen`
- `aquamarine`
- `cyan`
- `skyBlue`
- `dodgerBlue`
- `cornflowerBlue`
- `royalBlue`
- `blue`
- `deepBlue`
- `indigo`
- `violet`
- `purple`
- `fuschia`
- `magenta`
- `pink`
- `rose`

### Lightness

The lightness levels are number coded from **50 (lightest) to 950 (darkest)**. If you have used palettes like Material Colors or Tailwind Colors before, this should be familiar to you.

### Saturation

There is no letter for a 100% saturated color. Starting from 95%, the saturation levels are letter coded from **A (95% saturated) to S (5% saturation)**.

## Additional Information

- **Documentation**: Full API reference is available on [pub.dev](https://pub.dev/documentation/colorfull/latest). Use the sidebar to browse all color constants.
- **Issues & Contributions**: Found a bug or want to contribute? Open an issue or pull request on [GitHub](https://github.com/adifyr/colorfull).
- **Contact**: For questions, you can reach out via [GitHub Issues](https://github.com/adifyr/colorfull/issues).
