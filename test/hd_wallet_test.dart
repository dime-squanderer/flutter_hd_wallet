import 'package:flutter/foundation.dart';
import 'package:flutter_hd_wallet/src/bip44/bip44.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('test', () {
    final node = BIP44.fromSeed(
        "87fbb2c47e6cb3a8c5dc0eb9c6b86ac6d78c19a3a62ee6e3b59cb92fda2c9a58df77a691f450645f78ec98584edf9c7b4c25f2e414fc9f39e97ba6788f5311a0");
    const account = 0;
    const change = 0;
    const index = 2;
    debugPrint(node.privateKeyHex());
    debugPrint(node.publicKeyHex());
    debugPrint(
        node.privateKeyHex(account: account, change: change, index: index));
    debugPrint(
        node.publicKeyHex(account: account, change: change, index: index));
  });
}
