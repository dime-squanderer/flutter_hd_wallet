import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_hd_wallet/src/bip39/bip39.dart';
import 'package:flutter_hd_wallet/src/bip39/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';

void main() {
  // import vectors json
  final vectors = json.decode(
      File('./test/vectors/bip39.json').readAsStringSync(encoding: utf8));

  // Test bip39.dart
  group('bip39:', () {
    test('Size to strenth', () {
      expect(sizeToStrength(12), 128 ~/ 8);
      expect(sizeToStrength(15), 160 ~/ 8);
      expect(sizeToStrength(18), 192 ~/ 8);
      expect(sizeToStrength(21), 224 ~/ 8);
      expect(sizeToStrength(24), 256 ~/ 8);
    });

    test('Invalid entropy', () {
      final invalidHex = vectors['invalid_entropy']['hex'];
      for (var e in invalidHex) {
        expect(() => entropyToMnemonic(e), throwsArgumentError);
      }
    });

    test('Invalid entropy length', () {
      final invalidLength = vectors['invalid_entropy']['length'];
      for (var e in invalidLength) {
        expect(() => entropyToMnemonic(e), throwsArgumentError);
      }
    });

    test('Invalid mnemonic', () {
      final invalidMnemonic = vectors['invalid_mnemonic'];
      for (var m in invalidMnemonic) {
        bool isValid = validateMnemonic(m);
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
          expect(validateMnemonic(mnemonic), false);
        } else {
          final l = Language.values.firstWhere((e) => describeEnum(e) == lang,
              orElse: () => Language.unknown);
          final m = entropyToMnemonic(entropy, language: l);
          final s = mnemonicToSentence(m);
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
          final e = mnemonicToEntropy(mnemonic);
          expect(entropyToHex(e), entropy);
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
          final s = mnemonicToSeed(mnemonic, passphrase: passphrase);
          final sHex = HEX.encode(s);
          expect(sHex, seed);

          final sHexStr = mnemonicToSeedHex(mnemonic, passphrase: passphrase);
          expect(sHexStr, seed);
        }
      }
    });
  });

  group('BIP39 class:', () {
    test('generate mnemonice in different languages and lengths', () {
      for (final l in Language.values) {
        // if language is unknown, skip it
        if (l == Language.unknown) {
          continue;
        }
        // default word count is 12 words,
        // 15(160), 18(192), 21(224), 24(256)
        for (var i = 12; i <= 24; i += 3) {
          final bip39 = BIP39(language: l, count: i);
          expect(bip39.language, l.name);
          expect(bip39.mnemonic.length, i);
          // debugPrint("lang: $l, count: $i ${bip39.count} ${sizeToStrength(i)}");
          final words = bip39.mnemonic;
          final lang = mnemonicLanguage(words);
          expect(lang, l);
          // debugPrint("${words.length} words: ${words.join(" ")}");
        }
      }
    });

    test('Create BIP39 instance from mnemonic', () {
      final datas = vectors['mnemonic'];
      for (var data in datas) {
        final entropy = data['entropy'];
        final mnemonic = data['mnemonic'];
        final lang = data["language"];
        final passphrase = data['passphrase'];
        final seed = data['seed'];
        if (lang == "unknown") {
          expect(validateMnemonic(mnemonic), false);
        } else {
          final b = BIP39.fromMnemonic(mnemonic, passphrase: passphrase);
          final e = b.entropy;
          final s = b.sentence;
          final sh = b.seed;
          expect(e, entropy);
          expect(s, mnemonic);
          expect(sh, seed);
        }
      }
    });

    test('Create BIP39 instance from entropy hex string', () {
      final datas = vectors['mnemonic'];
      for (var data in datas) {
        final entropy = data['entropy'];
        final mnemonic = data['mnemonic'];
        final lang = data["language"];
        final passphrase = data['passphrase'];
        final seed = data['seed'];
        if (lang == "unknown") {
          expect(validateMnemonic(mnemonic), false);
        } else {
          final l = Language.values.firstWhere((e) => describeEnum(e) == lang,
              orElse: () => Language.unknown);
          final b =
              BIP39(entropy: entropy, language: l, passphrase: passphrase);
          final e = b.entropy;
          final s = b.sentence;
          final sh = b.seed;
          expect(e, entropy);
          expect(s, mnemonic);
          expect(sh, seed);
        }
      }
    });
  });
}
