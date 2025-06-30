// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:id_card_picker/id_card_picker.dart';

void main() {
  group('IdCardPicker', () {
    test('can be instantiated', () {
      expect(IdCardPicker(), isNotNull);
    });
  });
}
