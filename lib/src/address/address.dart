import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';

import '../utils/base58.dart' as base58;
import '../utils/crypto.dart';

// Ethereum-based address
String ethAddress(Uint8List pubk, {bool checksum = true}) {
  Uint8List uncompressed;
  if (pubk.length == 65) {
    if (pubk[0] == 0x04) {
      uncompressed = pubk.sublist(1);
    } else {
      throw ArgumentError("Invalid uncompressed public key");
    }
  } else if (pubk.length == 64) {
    uncompressed = pubk;
  } else {
    throw ArgumentError("Invalid uncompressed public key");
  }
  final keccakHash = keccak256(uncompressed);
  final keccakHex = HEX.encode(keccakHash);
  final address = "0x${keccakHex.substring(keccakHex.length - 40)}";
  if (checksum) {
    return ethChecksum(address);
  } else {
    return address;
  }
}

// Ethereum Checksum Address
String ethChecksum(String address) {
  final addr = address.toLowerCase().substring(2);
  final hashed = HEX.encode(keccak256(utf8.encode(addr) as Uint8List));

  String addrChecksum = "";
  for (var char in addr.split('')) {
    if ("0123456789".contains(char)) {
      addrChecksum += char;
    } else if ("abcdef".contains(char)) {
      // Check if the corresponding hex digit (nibble) in the hash is 8 or higher
      final hashedNibble = int.parse(hashed[addrChecksum.length], radix: 16);
      if (hashedNibble >= 8) {
        addrChecksum += char.toUpperCase();
      } else {
        addrChecksum += char;
      }
    } else {
      throw ArgumentError("Unrecognized hex character");
    }
  }
  return "0x$addrChecksum";
}

// Bitcoin-based address
String btcAddress(Uint8List pubk) {
  final sha256Hash = sha256(pubk);
  final ripemd160Hash = ripemd160(sha256Hash);
  const version = 0x00;
  final versionByte = Uint8List.fromList([version]);
  final versionedHash = Uint8List.fromList([...versionByte, ...ripemd160Hash]);
  final sha256Hash2 = sha256(versionedHash);
  final checksum = sha256(sha256Hash2).sublist(0, 4);
  final checksumed = Uint8List.fromList([...versionedHash, ...checksum]);
  final address = base58.encode(checksumed);
  return address;
}

// Bitcoin-based testnet address
String btcTestnetAddress(Uint8List pubk) {
  final sha256Hash = sha256(pubk);
  final ripemd160Hash = ripemd160(sha256Hash);
  const version = 0x6F;
  final versionByte = Uint8List.fromList([version]);
  final versionedHash = Uint8List.fromList([...versionByte, ...ripemd160Hash]);
  final sha256Hash2 = sha256(versionedHash);
  final checksum = sha256(sha256Hash2).sublist(0, 4);
  final checksumed = Uint8List.fromList([...versionedHash, ...checksum]);
  final address = base58.encode(checksumed);
  return address;
}
