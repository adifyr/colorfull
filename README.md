<p align="center"><img src="https://raw.githubusercontent.com/adifyr/colorfull/refs/heads/main/assets/logo.png" height="120"></p>

# Colorfull

**Colorfull** was created to solve a major limitation in popular design systems like Tailwind and Material Design: their woefully limited color palettes. There is no quick and easy way to access a large range of colors directly, making it difficult to build themes and design systems with true creative freedom.

Colorfull solves this by giving Flutter developers direct, instant access to the full palette of 11,421 colors derived from the HSL color wheel — covering 30 base hues × 20 saturation levels × 19 lightness levels + 19 shades of grey + black and white. Every color is exposed as a global constant for fast, type-safe access — making it easy to build beautiful, consistent UIs with complete flexibility.

### Infographic

<p align="center"><img src="https://raw.githubusercontent.com/adifyr/colorfull/refs/heads/main/assets/system.png"></p>

## Features

- 🌈 **11,421 Colors**: Every possible combination of 30 base hues, 20 saturation levels, and 19 lightness levels + 19 shades of grey + black and white.
- 🔎 **Global Constants**: All colors are available as named Dart constants — no need to calculate or convert.
- 🎨 **Consistent Naming**: Colors are organized and named for easy lookup and autocompletion.
- ⚡️ **Zero Dependencies**: Pure Dart/Flutter, no external dependencies.
- 🖼️ **Perfect for Design Systems**: Build beautiful, consistent UIs with fine-grained color control.
- 🌳 **Highly Tree-Shakeable**: Only the colors you use are included in your final app build, keeping your app size minimal.

## Getting Started

Add ColorFull to your `pubspec.yaml`:

```yaml
dependencies:
  colorfull: ^1.0.0
```

Then run:

```sh
flutter pub get
```

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
