# HD Wallet

A crypto HD wallet package for the Dart language.

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

Generate 24 Japanese words mnemonice:

```dart
// default strength is 128 bits (12 words),
// 160(15), 192(18), 224(21), 256(24)
final mnemonic = bip39.generateMnemonic(language: Language.japanese, strength: 256);
```

### Base58

```dart
const hex = '00010966776006953D5567439E5E39F86A0D273BEED61967F6';
final b58 = base58.encodeHex(hex);
// '16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM'

final hash = Uint8List.fromList(HEX.decode(hex));
final b58 = base58.encode(hash);
// '16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM'

final decoded = HEX.encode(base58.decode('16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM'));
// '00010966776006953D5567439E5E39F86A0D273BEED61967F6'
// 
```

## Additional information

If you have any problems or bugs in use, please contact us.
