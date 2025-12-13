sealed class Colorfull {
  static const baseColors = [
    'Red',
    'Deep Orange',
    'Pumpkin Orange',
    'Orange',
    'Amber',
    'Yellow',
    'Lime',
    'Lime Green',
    'Bright Green',
    'Neon Green',
    'Green',
    'Light Green',
    'Spring Green',
    'Sports Green',
    'Aquamarine',
    'Cyan',
    'Sky Blue',
    'Dodger Blue',
    'Cornflower Blue',
    'Royal Blue',
    'Blue',
    'Deep Blue',
    'Indigo',
    'Violet',
    'Purple',
    'Fuschia',
    'Magenta',
    'Pink',
    'Rose',
  ];

  static List<String> get baseColorVars {
    return baseColors.map((color) {
      final [part1, part2] = color.split(' ');
      return '${part1.toLowerCase()}$part2';
    }).toList();
  }
}
