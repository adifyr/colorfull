import 'package:flutter/services.dart';

export 'colors/red.dart';
export 'colors/deep_orange.dart';
export 'colors/pumpkin_orange.dart';
export 'colors/orange.dart';
export 'colors/amber.dart';
export 'colors/yellow.dart';
export 'colors/lime.dart';
export 'colors/lime_green.dart';
export 'colors/forest_green.dart';
export 'colors/neon_green.dart';
export 'colors/green.dart';
export 'colors/light_green.dart';
export 'colors/spring_green.dart';
export 'colors/sports_green.dart';
export 'colors/aquamarine.dart';
export 'colors/cyan.dart';
export 'colors/sky_blue.dart';
export 'colors/dodger_blue.dart';
export 'colors/cornflower_blue.dart';
export 'colors/royal_blue.dart';
export 'colors/blue.dart';
export 'colors/deep_blue.dart';
export 'colors/indigo.dart';
export 'colors/violet.dart';
export 'colors/purple.dart';
export 'colors/fuschia.dart';
export 'colors/magenta.dart';
export 'colors/pink.dart';
export 'colors/rose.dart';
export 'colors/rose_red.dart';

extension ColorUtils on Color {
  Color operator *(final double alpha) => withValues(alpha: alpha);
}
