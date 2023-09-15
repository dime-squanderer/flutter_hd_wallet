# HD Wallet

A basic toolkit for Cryptocurrency wallet in Dart. This package is used to generate and manage the Hierarchical Deterministic (HD) Wallet application.

## Features

You can easily use this package to develop crypto wallets through the Dart language.

## Getting started

### Use this package as a library

Depend on it

Run this command:

With Dart:

```sh
dart pub add hd_wallet
```

With Flutter:

```sh
flutter pub add hd_wallet
```

This will add a line like this to your package's pubspec.yaml (and run an implicit `dart pub get`):

```sh
dependencies:
  hd_wallet: ^latest
```

Alternatively, your editor might support dart pub get or flutter pub get. Check the docs for your editor to learn more.

### Import it

Now in your Dart code, you can use:

```dart
import 'package:hd_wallet/hd_wallet.dart';
```

## Usage

Short and useful examples for package users. Longer examples
is in `/example` folder.

### Bip39

Generate mnemonice:

```dart
// default mnemonic is 12 english words,
final m = bip39.BIP39();
debugPrint("words: ${m.mnemonic}");
debugPrint("seed: ${m.seed}");
```

### Bip32

Forked from [bip32-dart](https://github.com/dart-bitcoin/bip32-dart) and improve some flaws.

```dart
bip32.BIP32 node = bip32.BIP32.fromBase58(
        'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi');
final nodePrvk = HEX.encode(node.privateKey as List<int>);
debugPrint("nodePrvk: $nodePrvk");
// => e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35

bip32.BIP32 nodeNeutered = node.neutered();
debugPrint("isNeutered: ${nodeNeutered.isNeutered()}");
// => true

debugPrint(HEX.encode(nodeNeutered.publicKey));
// => 0339a36013301597daef41fbe593a02cc513d0b55527ec2df1050e2e8ff49c85c2

debugPrint(nodeNeutered.toBase58());
// => xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8

bip32.BIP32 child = node.derivePath('m/0/0');
debugPrint(child.toBase58());
// => xprv9ww7sMFLzJMzur2oEQDB642fbsMS4q6JRraMVTrM9bTWBq7NDS8ZpmsKVB4YF3mZecqax1fjnsPF19xnsJNfRp4RSyexacULXMKowSACTRc

debugPrint(HEX.encode(child.privateKey as List<int>));
// => f26cf12f89ab91aeeb8d7324a22e8ba080829db15c9245414b073a8c342322aa

bip32.BIP32 childNeutered = child.neutered();
debugPrint("childNeutered isNeutered: ${childNeutered.isNeutered()}");
// => true

debugPrint(HEX.encode(childNeutered.publicKey));
// => 02756de182c5dd4b717ea87e693006da62dbb3cddaa4a5cad2ed1f5bbab755f0f5

bip32.BIP32 nodeFromSeed = bip32.BIP32.fromSeed(
    Uint8List.fromList(HEX.decode("000102030405060708090a0b0c0d0e0f")));
debugPrint(nodeFromSeed.toBase58());
// => xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi

bip32.BIP32 nodeFromPub = bip32.BIP32.fromBase58(
    "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8");
debugPrint(nodeFromPub.toBase58());
// => xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8

```

## Additional information

If you have any problems or bugs in use, please contact us.
