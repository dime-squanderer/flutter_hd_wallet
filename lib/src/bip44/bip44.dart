import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';

import '../address/address.dart';
import '../bip32/bip32.dart';
import '../bip39/bip39.dart';
import '../utils/coins.dart';

class BIP44 {
  final int _purpose = 44;
  final int _coinType;
  BIP32 _node;

  // initialize
  BIP44({required BIP32 node, int coinType = 0, bool hardened = false})
      : _node = node,
        _coinType = coinType;

  Uint8List? privateKey(
          {account = 0, change = 0, index = 0, hardened = false}) =>
      _node
          .derivePath(
              "m/$_purpose'/$_coinType'/$account'/$change/$index${hardened ? "'" : ""}")
          .privateKey;

  Uint8List privateKeyHardened({account = 0, change = 0, index = 0}) =>
      privateKey(
          account: account, change: change, index: index, hardened: true)!;

  String privateKeyHex(
          {account = 0, change = 0, index = 0, hardened = false}) =>
      HEX.encode(privateKey(
          account: account, change: change, index: index, hardened: hardened)!);

  String privateKeyHardenedHex({account = 0, change = 0, index = 0}) =>
      HEX.encode(
          privateKeyHardened(account: account, change: change, index: index));

  Uint8List publicKey({account = 0, change = 0, index = 0, hardened = false}) =>
      _node
          .derivePath(
              "m/$_purpose'/$_coinType'/$account'/$change/$index${hardened ? "'" : ""}")
          .publicKey;

  Uint8List publicKeyHardened({account = 0, change = 0, index = 0}) =>
      publicKey(account: account, change: change, index: index, hardened: true);

  String publicKeyHex({account = 0, change = 0, index = 0, hardened = false}) =>
      HEX.encode(publicKey(
          account: account, change: change, index: index, hardened: hardened));

  String publicKeyHardenedHex({account = 0, change = 0, index = 0}) =>
      HEX.encode(
          publicKeyHardened(account: account, change: change, index: index));

  Uint8List publicKeyUncompressed(
          {account = 0, change = 0, index = 0, hardened = false}) =>
      _node
          .derivePath(
              "m/$_purpose'/$_coinType'/$account'/$change/$index${hardened ? "'" : ""}")
          .publicKeyUncompressed;

  String address(
      {account = 0,
      change = 0,
      index = 0,
      hardened = false,
      bool checksum = true}) {
    final t = coins[_coinType]!["type"];

    switch (t) {
      case '0':
        final pubk = publicKey(
            account: account, change: change, index: index, hardened: hardened);
        const version = 0x00;
        return btcAddress(pubk, version);
      case '1':
        final pubk = publicKey(
            account: account, change: change, index: index, hardened: hardened);
        const version = 0x6F;
        return btcAddress(pubk, version);
      // default: coin type = 60, ethereum address
      default:
        final pubk = publicKeyUncompressed(
            account: account, change: change, index: index, hardened: hardened);
        return ethAddress(pubk, checksum: checksum);
    }
  }

  factory BIP44.fromMnemonic(String mnemonic,
      {String passphrase = "", int coinType = 0}) {
    final node =
        BIP32.fromSeed(mnemonicToSeed(mnemonic, passphrase: passphrase));
    return BIP44(
      node: node,
      coinType: coinType,
    );
  }

  factory BIP44.fromSeed(String seed, {int coinType = 0}) {
    final s = Uint8List.fromList(HEX.decode(seed));
    final node = BIP32.fromSeed(s);
    return BIP44(
      node: node,
      coinType: coinType,
    );
  }

  factory BIP44.fromBase58(String base58, {int coinType = 0}) {
    final node = BIP32.fromBase58(base58);
    return BIP44(
      node: node,
      coinType: coinType,
    );
  }
}
