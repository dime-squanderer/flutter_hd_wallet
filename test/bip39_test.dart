import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';

import 'package:hd_wallet/src/bip39/bip39.dart' as bip39;
import 'package:hd_wallet/src/bip39/language.dart';

void main() {
  // import vectors json
  final vectors = json.decode(
      File('./test/vectors/bip39.json').readAsStringSync(encoding: utf8));

  // Test bip39.dart
  group('test', () {
    test('generate mnemonice in different languages and lengths', () {
      for (final l in Language.values) {
        // if language is unknown, skip it
        if (l == Language.unknown) {
          continue;
        }
        // default strength is 128 bits (12 words),
        // 160(15), 192(18), 224(21), 256(24)
        for (var i = 128; i <= 256; i += 32) {
          final mnemonic = bip39.generateMnemonic(language: l, strength: i);
          expect(bip39.mnemonicLanguage(mnemonic), l);
          expect(mnemonic.length, i ~/ 32 * 3);
        }
      }
    });

    test('Invalid entropy', () {
      final invalidHex = vectors['invalid_entropy']['hex'];
      for (var e in invalidHex) {
        expect(() => bip39.entropyToMnemonic(e), throwsArgumentError);
      }
    });

    test('Invalid entropy length', () {
      final invalidLength = vectors['invalid_entropy']['length'];
      for (var e in invalidLength) {
        expect(() => bip39.entropyToMnemonic(e), throwsArgumentError);
      }
    });

    test('Invalid mnemonic', () {
      final invalidMnemonic = vectors['invalid_mnemonic'];
      for (var m in invalidMnemonic) {
        bool isValid = bip39.validateMnemonic(m);
        expect(isValid, false);
      }
    });

    test('entropy to mnemonic', () {
      final datas = vectors['mnemonic'];
      for (var data in datas) {
        final entropy = data['entropy'];
        final mnemonic = data['mnemonic'];
        final lang = data["language"];
        if (lang == "unknown") {
          expect(bip39.validateMnemonic(mnemonic), false);
        } else {
          final l = Language.values.firstWhere((e) => describeEnum(e) == lang,
              orElse: () => Language.unknown);
          final m = bip39.entropyToMnemonic(entropy, language: l);
          final s = bip39.mnemonicToSentence(m);
          expect(s, mnemonic);
        }
      }
    });

    test('mnemonic to entropy', () {
      final datas = vectors['mnemonic'];
      for (var data in datas) {
        final entropy = data['entropy'];
        final mnemonic = data['mnemonic'];
        final lang = data["language"];
        if (lang == "unknown") {
          continue;
        } else {
          // mnemonic string to list
          final e = bip39.mnemonicToEntropy(mnemonic);
          expect(bip39.entropyToHex(e), entropy);
        }
      }
    });

    // test mnemonic to seed
    test('mnemonic to seed and seed hex string', () {
      final datas = vectors['mnemonic'];
      for (var data in datas) {
        final seed = data['seed'];
        final mnemonic = data['mnemonic'];
        final passphrase = data['passphrase'];
        final lang = data["language"];
        if (lang == "unknown") {
          continue;
        } else {
          final s = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);
          final sHex = HEX.encode(s);
          expect(sHex, seed);

          final sHexStr =
              bip39.mnemonicToSeedHex(mnemonic, passphrase: passphrase);
          expect(sHexStr, seed);
        }
      }
    });
  });
}
