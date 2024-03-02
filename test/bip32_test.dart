import 'package:flutter/foundation.dart';
import 'package:flutter_hd_wallet/src/bip32/bip32.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';

void main() {
  test('test BIP32', () {
    BIP32 node = BIP32.fromBase58(
        'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi');
    final nodePrvk = HEX.encode(node.privateKey as List<int>);
    // debugPrint("nodePrvk: $nodePrvk");
    // => e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35
    expect(nodePrvk,
        "e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35");

    BIP32 nodeNeutered = node.neutered();
    // debugPrint("isNeutered: ${nodeNeutered.isNeutered()}");
    // => true

    // debugPrint(HEX.encode(nodeNeutered.publicKey));
    // => 0339a36013301597daef41fbe593a02cc513d0b55527ec2df1050e2e8ff49c85c2
    expect(HEX.encode(nodeNeutered.publicKey),
        "0339a36013301597daef41fbe593a02cc513d0b55527ec2df1050e2e8ff49c85c2");

    // debugPrint(nodeNeutered.toBase58());
    // => xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8
    expect(nodeNeutered.toBase58(),
        "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8");

    BIP32 child = node.derivePath('m/0/0');
    // debugPrint(child.toBase58());
    // => xprv9ww7sMFLzJMzur2oEQDB642fbsMS4q6JRraMVTrM9bTWBq7NDS8ZpmsKVB4YF3mZecqax1fjnsPF19xnsJNfRp4RSyexacULXMKowSACTRc
    expect(child.toBase58(),
        "xprv9ww7sMFLzJMzur2oEQDB642fbsMS4q6JRraMVTrM9bTWBq7NDS8ZpmsKVB4YF3mZecqax1fjnsPF19xnsJNfRp4RSyexacULXMKowSACTRc");

    // debugPrint(HEX.encode(child.privateKey as List<int>));
    // => f26cf12f89ab91aeeb8d7324a22e8ba080829db15c9245414b073a8c342322aa
    expect(HEX.encode(child.privateKey as List<int>),
        "f26cf12f89ab91aeeb8d7324a22e8ba080829db15c9245414b073a8c342322aa");

    BIP32 childNeutered = child.neutered();
    // debugPrint("childNeutered isNeutered: ${childNeutered.isNeutered()}");
    // => true

    // debugPrint(HEX.encode(childNeutered.publicKey));
    // => 02756de182c5dd4b717ea87e693006da62dbb3cddaa4a5cad2ed1f5bbab755f0f5
    expect(HEX.encode(childNeutered.publicKey),
        "02756de182c5dd4b717ea87e693006da62dbb3cddaa4a5cad2ed1f5bbab755f0f5");

    BIP32 nodeFromSeed = BIP32.fromSeed(
        Uint8List.fromList(HEX.decode("000102030405060708090a0b0c0d0e0f")));
    // debugPrint(nodeFromSeed.toBase58());
    // => xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi
    expect(nodeFromSeed.toBase58(),
        "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi");

    BIP32 nodeFromPub = BIP32.fromBase58(
        "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8");
    // debugPrint(nodeFromPub.toBase58());
    // => xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8
    expect(nodeFromPub.toBase58(),
        "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8");
  });
}
