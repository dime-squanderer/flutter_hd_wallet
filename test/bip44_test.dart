import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hex/hex.dart';
import 'package:hd_wallet/src/bip32/bip32.dart' as bip32;

void main() {
  test('test', () {
    final node = bip32.BIP32.fromSeed(Uint8List.fromList(HEX.decode(
        "87fbb2c47e6cb3a8c5dc0eb9c6b86ac6d78c19a3a62ee6e3b59cb92fda2c9a58df77a691f450645f78ec98584edf9c7b4c25f2e414fc9f39e97ba6788f5311a0")));
    debugPrint(node.toBase58());

    final child = node.derivePath("m/44'/0'/0'/0/4294967295");
    debugPrint(child.toWIF());
    final childPub = child.publicKey;
    debugPrint(HEX.encode(childPub));
  });
}
