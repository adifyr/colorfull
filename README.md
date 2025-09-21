# ColorFull

**ColorFull** is a Flutter package that gives developers access to the full range of 12,000 HSL-based colors—making it easy to use precise colors in your apps. With 30 hues × 20 saturation levels × 20 lightness levels, every color is exposed as a global constant for fast, type-safe access.

## Features

- 🌈 **12,000 Colors**: Every possible combination of 30 hues, 20 saturations, and 20 lightness levels.
- 🔎 **Global Constants**: All colors are available as named Dart constants — no need to calculate or convert.
- 🎨 **Consistent Naming**: Colors are organized and named for easy lookup and autocompletion.
- ⚡ **Zero Dependencies**: Pure Dart/Flutter, no external dependencies.
- 🖼️ **Perfect for Design Systems**: Build beautiful, consistent UIs with fine-grained color control.

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

Import the package and use any color constant:

```dart
import 'package:colorfull/colorfull.dart';

// Example: Use a vivid indigo color
Container(
  color: indigo650, // Or any other color constant
  padding: const EdgeInsets.all(16.0),
  child: Text('Hello ColorFull!', style: TextStyle(color: Colors.white)),
);

// Example: Use a specific hue, saturation, and lightness
Text('Dodger Blue A-300', style: TextStyle(color: dodgerBlueA300))
```

All colors are available as constants like `limeGreen`, `pumpkinOrange150`, `redA400`, `cyanQ750`, etc. See the API reference on [pub.dev](https://pub.dev/documentation/colorfull/latest) for the full list.

## Additional Information

- **Documentation**: Full API reference is available on [pub.dev](https://pub.dev/documentation/colorfull/latest). Use the sidebar to browse all color constants.
- **Issues & Contributions**: Found a bug or want to contribute? Open an issue or pull request on [GitHub](https://github.com/adifyr/colorfull).
- **Contact**: For questions, you can reach out via [GitHub Issues](https://github.com/adifyr/colorfull/issues).
