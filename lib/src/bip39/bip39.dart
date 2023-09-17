import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256;
import 'package:hex/hex.dart';
import 'package:unorm_dart/unorm_dart.dart';

import 'language.dart';
import '../utils/pbkdf2.dart';

const int _sizeByte = 256;
const _invalidMnemonic = 'Invalid mnemonic';
const _invalidEntropy = 'Invalid entropy';
const _invalidChecksum = 'Invalid checksum';

typedef RandomBytes = Uint8List Function(int size);

Uint8List _randomBytes(int strength) {
  final rng = Random.secure();
  final bytes = Uint8List(strength);
  for (var i = 0; i < strength; i++) {
    bytes[i] = rng.nextInt(_sizeByte);
  }
  return bytes;
}

dynamic _hexToBytes(String hex) {
  if (hex.runtimeType == Null) {
    return Null;
  } else {
    return Uint8List.fromList(HEX.decode(hex));
  }
}

int _binaryToByte(String binary) {
  return int.parse(binary, radix: 2);
}

String _bytesToBinary(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
}

/// This function is used to convert binary to int.
///
/// It is used to convert the sha256 hash of the entropy to int.
int _binaryToInt(String binary) {
  return int.parse(binary, radix: 2);
}

String _entropyChecksumBits(Uint8List entropy) {
  final ent = entropy.length * 8;
  final cs = ent ~/ 32;
  final hash = sha256.convert(entropy);
  return _bytesToBinary(Uint8List.fromList(hash.bytes)).substring(0, cs);
}

List<String> entropyToMnemonic(String entropyString,
    {Language language = Language.english}) {
  // check if entropy is valid
  if (validateEntropy(entropyString) == false) {
    throw ArgumentError(_invalidEntropy);
  }
  final entropy = Uint8List.fromList(HEX.decode(entropyString));
  final entropyBits = _bytesToBinary(entropy);
  final checksumBits = _entropyChecksumBits(entropy);
  final bits = entropyBits + checksumBits;
  final regex = RegExp(r".{1,11}", caseSensitive: false, multiLine: false);
  final chunks = regex
      .allMatches(bits)
      .map((match) => match.group(0)!)
      .toList(growable: false);
  List<String> wordlist = language.wordlist;
  List<String> words = chunks
      .map((binary) => wordlist[_binaryToByte(binary)])
      .toList(growable: false);
  return words;
}

List<String> generateMnemonic(
    {Language language = Language.english,
    int strength = 128,
    RandomBytes randomBytes = _randomBytes}) {
  assert(strength % 32 == 0);
  final entropy = randomBytes(strength ~/ 8);
  return entropyToMnemonic(HEX.encode(entropy), language: language);
}

List<String> formatMnemonic(var mnemonic) {
  List<String> words = [];

  if (mnemonic is String) {
    var sentence = mnemonic.replaceAll(RegExp(r'[\s+,，]'), ' ');
    sentence = sentence.trim();
    sentence = sentence.toLowerCase();
    words = sentence.split(RegExp(r'\s+'));
  } else if (mnemonic is List<String>) {
    words = mnemonic;
  } else {
    throw ArgumentError(_invalidMnemonic);
  }
  return words;
}

/// This function is used to check mnemonic list language.
///
/// If the mnemonic list is not in any language, it will return unknown.
/// If the mnemonic list is in more than one language, it will return unknown.
Language mnemonicLanguage(var mnemonic) {
  final words = formatMnemonic(mnemonic);
  for (final l in Language.values) {
    final list = l.wordlist;
    var matched = 0;
    for (final m in words) {
      if (!list.contains(m)) {
        break;
      }
      matched++;
    }
    if (matched == words.length) {
      return l;
    }
  }
  return Language.unknown;
}

String mnemonicToSentence(List<String> mnemonic) {
  final language = mnemonicLanguage(mnemonic);
  if (language == Language.unknown) {
    throw ArgumentError(_invalidMnemonic);
  }
  return mnemonic.join(language.delimiter);
}

Uint8List mnemonicToSeed(var mnemonic, {String passphrase = ''}) {
  final words = formatMnemonic(mnemonic);
  final sentence = nfkd(mnemonicToSentence(words));
  final pbkdf2 = PBKDF2();
  return pbkdf2.process(sentence, passphrase: passphrase);
}

String mnemonicToSeedHex(var mnemonic, {String passphrase = ""}) {
  return mnemonicToSeed(mnemonic, passphrase: passphrase).map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
}

/// This function is used to compute entropy from mnemonic.
Uint8List mnemonicToEntropy(var mnemonic) {
  final language = mnemonicLanguage(mnemonic);
  if (language == Language.unknown) {
    throw ArgumentError(_invalidMnemonic);
  }
  final words = formatMnemonic(mnemonic);
  final list = language.wordlist;
  final bits = words.map((word) {
    final index = list.indexOf(word);
    if (index == -1) {
      throw ArgumentError(_invalidMnemonic);
    }
    return index.toRadixString(2).padLeft(11, '0');
  }).join('');
  final entropyBits = bits.substring(0, bits.length - bits.length ~/ 33);
  final dividerIndex = (bits.length ~/ 33) * 32;
  final checksumBits = bits.substring(dividerIndex);

  final regex = RegExp(r".{1,8}", caseSensitive: false, multiLine: false);
  final chunks = regex.allMatches(entropyBits).map((m) => m.group(0)).toList();
  final entropy = chunks.map((binary) => _binaryToInt(binary!)).toList();

  // calculate the checksum and compare
  final newChecksum = _entropyChecksumBits(Uint8List.fromList(entropy));
  if (newChecksum != checksumBits) {
    throw StateError(_invalidChecksum);
  }

  return Uint8List.fromList(entropy);
}

// entropy to hex
String entropyToHex(Uint8List entropy) {
  return HEX.encode(entropy);
}

int sizeToStrength(int size) {
  return size * 32 ~/ 3 ~/ 8;
}

int entropyToStrength(String entropy) {
  return entropy.length * 8 ~/ 3;
}

bool validateEntropy(String entropy) {
  if (entropy.runtimeType == Null) return false;
  try {
    // check if entropy is valid
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(entropy)) {
      throw ArgumentError(_invalidEntropy);
    }
    final entropyBytes = Uint8List.fromList(HEX.decode(entropy));
    // debugPrint("entropyBytes.length: ${entropyBytes.length}");
    // debugPrint("entropy.lenth: ${entropy.length}");
    if (entropyBytes.length < 16) {
      throw ArgumentError(_invalidEntropy);
    }
    if (entropyBytes.length > 32) {
      throw ArgumentError(_invalidEntropy);
    }
    if (entropyBytes.length % 4 != 0) {
      throw ArgumentError(_invalidEntropy);
    }
  } catch (e) {
    return false;
  }
  return true;
}

bool validateMnemonic(var mnemonic) {
  List<String> words = formatMnemonic(mnemonic);

  try {
    mnemonicToEntropy(words);
  } catch (e) {
    return false;
  }
  return true;
}

class BIP39 {
  Language _language = Language.english;
  Uint8List _entropy;
  String _passphrase;

  BIP39({
    language = Language.english,
    entropy,
    passphrase = "",
    count = 12,
  })  : _language = language,
        _entropy = (entropy.runtimeType != Null)
            ? _hexToBytes(entropy)
            : _randomBytes(sizeToStrength(count)),
        _passphrase = passphrase;

  List<String> get mnemonic => entropyToMnemonic(entropy, language: _language);
  String get sentence => mnemonicToSentence(mnemonic);
  String get seed => mnemonicToSeedHex(mnemonic, passphrase: _passphrase);
  String get entropy => entropyToHex(_entropy);
  String get language => _language.name;

  factory BIP39.fromMnemonic(String mnemonic, {String passphrase = ""}) {
    final language = mnemonicLanguage(mnemonic);
    final words = formatMnemonic(mnemonic);
    final entropy = mnemonicToEntropy(words);
    return BIP39(
        language: language,
        entropy: entropyToHex(entropy),
        passphrase: passphrase);
  }

  factory BIP39.fromEntropy(String entropy,
      {Language language = Language.english, String passphrase = ""}) {
    // check if entropy is valid
    if (validateEntropy(entropy) == false) {
      throw ArgumentError(_invalidEntropy);
    }
    return BIP39(
        language: language,
        entropy: _hexToBytes(entropy),
        passphrase: passphrase);
  }
}
