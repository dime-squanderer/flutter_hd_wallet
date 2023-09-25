import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hex/hex.dart';

import 'package:hd_wallet/src/utils/crypto.dart';
import 'package:hd_wallet/src/utils/base58.dart' as base58;
import 'package:hd_wallet/src/bip44/bip44.dart';

void main() {
  test("Address", () {
    const mnomenic =
        "mail share black symptom major mushroom smart army rocket blanket high other";
    final node = BIP44.fromMnemonic(mnomenic, coinType: 519);
    final prvk = node.privateKey(index: 10, hardened: true);
    debugPrint("prvk: ${HEX.encode(prvk as List<int>)}");
    final pubk = node.publicKey(index: 10, hardened: true);
    debugPrint("pubk: ${HEX.encode(pubk)}");
    final addr = node.address(index: 10, hardened: true, checksum: false);
    debugPrint("addr: $addr");
    final addrc = node.address(index: 10, hardened: true);
    debugPrint("addc: $addrc");
    debugPrint("cccc: 0x9bB4E6a33C69E19A9B5B3591EAFC7054bb703635");
    // 0x9bB4E6a33C69E19A9B5B3591EAFC7054bb703635

    // final node2 = BIP44.fromMnemonic(mnomenic);
    // final addr2 = node2.address(index: 10, hardened: true);
    // debugPrint("addr2: $addr2");
  });

  test('bitcoin', () {
    // seed
    // 8b3130f40866228eb70cd313e7a82671ecdcf9ae86fe5d9c129cf11038b133d7d286361145d59035eaace867310524a14c40eb784e24165b0fc42597279b36d2
    // const pubk =
    // "03c7617044e26cc1188d46cbf763607d970e6e6a8700afb1e857f31ac424767cd5";

    const pubk =
        "028df992f54a7ad8c99e60f89049587e5ad6a4ea36730a14e24ce29238c0e40619";
    debugPrint("pubk: $pubk, length: ${pubk.length}");
    final sha256Hash = sha256(HEX.decode(pubk) as Uint8List);
    debugPrint(
        "sha256Hash: ${HEX.encode(sha256Hash)}, length: ${sha256Hash.length}");
    final ripemd160Hash = ripemd160(sha256Hash);
    debugPrint(
        "ripemd160Hash: ${HEX.encode(ripemd160Hash)}, length: ${ripemd160Hash.length}");

    const version = 0x00;
    final versionByte = Uint8List.fromList([version]);
    final versionedHash =
        Uint8List.fromList([...versionByte, ...ripemd160Hash]);
    debugPrint(
        "versionedHash: ${HEX.encode(versionedHash)}, length: ${versionedHash.length}");

    final sha256Hash2 = sha256(versionedHash);
    debugPrint(
        "sha256Hash2: ${HEX.encode(sha256Hash2)}, length: ${sha256Hash2.length}");
    final checksum = sha256(sha256Hash2).sublist(0, 4);
    debugPrint("checksum: ${HEX.encode(checksum)}, length: ${checksum.length}");

    final checksumed = Uint8List.fromList([...versionedHash, ...checksum]);
    debugPrint(
        "checksumed: ${HEX.encode(checksumed)}, length: ${checksumed.length}");

    final address = base58.encode(checksumed);
    debugPrint("address: $address");

    // const unBs58 = "0091B1621BF92D171897E5B18C0B6EF775B24082000E538589";
    // final unBs58Bin = HEX.decode(unBs58) as Uint8List;
    // final addr58 = base58.encode(unBs58Bin);
    // debugPrint("addr58: $addr58");
  });
  test('test address', () {
    const account = 0;
    const change = 0;
    const index = 10;
    const hardened = true;
    const mnomenic =
        "record apart bundle alpha random sword pitch universe split edge tip theme month sight hope";
    final node = BIP44.fromMnemonic(mnomenic, coinType: 60);

    final pubk = node.publicKey(
        account: account, change: change, index: index, hardened: hardened);
    debugPrint("pubk: ${HEX.encode(pubk)}, length: ${pubk.length}");

    Uint8List uncompress = node.publicKeyUncompressed(
        account: account, change: change, index: index, hardened: hardened);
    final uncompressedStr = HEX.encode(uncompress);
    debugPrint(
        "Uncompressed:    $uncompressedStr, length: ${uncompress.length}");
    if (uncompress.length > 64) {
      if (uncompress[0] == 0x04) {
        uncompress = uncompress.sublist(1);
      } else {
        throw ArgumentError("Expected uncompressed public key");
      }
    }

    final keccakHash = keccak256(uncompress);
    final keccakHex = HEX.encode(keccakHash);
    debugPrint("keccakHash: $keccakHex , ${keccakHash.length}");
    final pubkAddr = keccakHex.substring(keccakHex.length - 40);
    debugPrint("pubkAddr: 0x$pubkAddr");
  });
}
