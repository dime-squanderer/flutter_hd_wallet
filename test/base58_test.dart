import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hex/hex.dart';

import 'package:hd_wallet/src/base58/base58.dart' as base58;

void main() {
  test('base58', () {
    const hex = '00010966776006953D5567439E5E39F86A0D273BEED61967F6';
    final hash = Uint8List.fromList(HEX.decode(hex));
    const b58 = '16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM';
    expect(base58.encode(hash), b58);
    expect(base58.encodeHex(hex), b58);
    expect(base58.decode(b58), hash);
    final dh = HEX.encode(base58.decode(b58));
    debugPrint(dh);
  });
}
