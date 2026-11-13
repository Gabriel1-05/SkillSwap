import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/core/utils/validators.dart';

void main() {
  group('validateEmail', () {
    test('accepts a trimmed email address', () {
      expect(validateEmail('  learner@example.com  '), isNull);
    });

    test('rejects empty and malformed addresses', () {
      expect(validateEmail(' '), 'Format email tidak valid.');
      expect(validateEmail('learner@'), 'Format email tidak valid.');
    });
  });

  group('validatePassword', () {
    test('requires at least eight characters', () {
      expect(validatePassword('1234567'), 'Kata sandi minimal 8 karakter.');
      expect(validatePassword('12345678'), isNull);
    });
  });

  group('validateName', () {
    test('trims whitespace and enforces the supported length', () {
      expect(validateName(' A '), 'Nama harus 2 sampai 50 karakter.');
      expect(validateName(' Learner '), isNull);
      expect(
        validateName(List.filled(51, 'a').join()),
        'Nama harus 2 sampai 50 karakter.',
      );
    });
  });
}
