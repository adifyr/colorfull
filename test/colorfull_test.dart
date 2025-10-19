import 'package:colorfull/colorfull.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Swatch color generation', () {
    final someRed = Swatch(0xffFC4901);
    expect(someRed.m250.getHex(), '#E86530');
  });
}
