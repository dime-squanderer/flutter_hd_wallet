import 'package:flutter_test/flutter_test.dart';

import 'package:hd_wallet/src/bip39/bip39.dart' as bip39;
import 'package:hd_wallet/src/bip39/language.dart';

void main() {
  // Test bip39.dat
  group('test', () {
    test('generate mnemonice in different languages and lengths', () {
      for (final l in Language.values) {
        // if language is unknown, skip it
        if (l == Language.unknown) {
          continue;
        }
        // default length is 128 bits (12 words),
        // 160(15), 192(18), 224(21), 256(24)
        for (var i = 128; i <= 256; i += 32) {
          final mnemonic = bip39.generateMnemonic(language: l, strength: i);
          expect(bip39.mnemonicLanguage(mnemonic), l);
          expect(mnemonic.length, i ~/ 32 * 3);
        }
      }
    });
  });
}
