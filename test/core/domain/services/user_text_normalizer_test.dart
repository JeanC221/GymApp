import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/domain/services/user_text_normalizer.dart';

void main() {
  group('UserTextNormalizer', () {
    test('capitalizes each word and trims repeated whitespace', () {
      expect(
        UserTextNormalizer.normalizeTitle('  pull   latdown  '),
        'Pull Latdown',
      );
    });

    test('preserves known acronyms', () {
      expect(UserTextNormalizer.normalizeTitle('rdl'), 'RDL');
      expect(UserTextNormalizer.normalizeTitle('hiit cardio'), 'HIIT Cardio');
    });

    test('capitalizes hyphenated names correctly', () {
      expect(UserTextNormalizer.normalizeTitle('t-bar row'), 'T-Bar Row');
    });
  });
}