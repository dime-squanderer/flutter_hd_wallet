import 'package:flutter_hd_wallet/src/bip44/bip44.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bip44:', () {
    test('eth test', () {
      const coin = 60;
      const account = 0;
      const change = 0;
      const index = 1024;
      final node = BIP44.fromSeed(
          "87fbb2c47e6cb3a8c5dc0eb9c6b86ac6d78c19a3a62ee6e3b59cb92fda2c9a58df77a691f450645f78ec98584edf9c7b4c25f2e414fc9f39e97ba6788f5311a0",
          coinType: coin);

      expect(
        node.privateKeyHex(),
        "126b43a322b80d0f18bbdef0fd455fe680d78b7c038b243a5b5d40e331b032d7",
      );

      expect(
        node.publicKeyHex(),
        "02b6f32dde6031f55787fbf9d861c233526b53c56e30c854ebd61fc6ed681fc91d",
      );

      expect(
        node.privateKeyHex(hardened: true),
        "07590f06719e5b561b2323568a668ac21c4ca327a28960534ef0b392148fa180",
      );

      expect(
        node.publicKeyHex(hardened: true),
        "03e6dd25138127138140a0af34d214c9f006e2d6d475eed3fac0c2659ff2c1eacf",
      );

      expect(
        node.privateKeyHex(account: account, change: change, index: index),
        "f033d0f338838555d2842a33e21cbf59a49a3537cd494bff7ada534cbc118243",
      );

      expect(
        node.publicKeyHex(account: account, change: change, index: index),
        "02d3464e4d0504a6eed97299e85975fdf5be29cb1d1c49f6d217113bc7d77181b2",
      );

      expect(
        node.privateKeyHex(
            account: account, change: change, index: index, hardened: true),
        "155105f81999676268d15ba007aff2f8f391d7f21df2c9a50b39fd58f62de546",
      );

      expect(
        node.publicKeyHex(
            account: account, change: change, index: index, hardened: true),
        "03e6859749a3b614748046b820fb3f3496d1116734e3e2acb67bf25f6a91fb6cc9",
      );

      expect(
          node.address(index: 1), "0x2071fC489F9998d8C6674176655F18D73AFa5Aaa");

      expect(node.address(index: 2, hardened: true),
          "0x487d87C2aCC6272Aad9CdF2cCb98cC06a4e989ae");
    });

    test('test btc', () {
      const coin = 0;
      const account = 0;
      const change = 0;
      const index = 1024;
      final node = BIP44.fromSeed(
          "87fbb2c47e6cb3a8c5dc0eb9c6b86ac6d78c19a3a62ee6e3b59cb92fda2c9a58df77a691f450645f78ec98584edf9c7b4c25f2e414fc9f39e97ba6788f5311a0",
          coinType: coin);

      expect(
        node.privateKeyHex(),
        "91d71f20372a42b281434dc08d1a840c56141128cd7c3c5f1c11b955efbb65a8",
      );

      expect(
        node.publicKeyHex(),
        "03483f9abc50ae6af3e942dc9861d367ffc84cc125bc8492f280491ead44479fa8",
      );

      expect(
        node.privateKeyHex(hardened: true),
        "d46965d83005aae467d1080dad11b13327bedda10c021412abfac4ccb1f611b8",
      );

      expect(
        node.publicKeyHex(hardened: true),
        "020fbc9bfe208cc0d3eaf2113e57bf185e55456bb7c1ce3fa26176018076144ada",
      );

      expect(
        node.privateKeyHex(account: account, change: change, index: index),
        "af301c91c5645bacea3c7c813ca048fc660cf34163a5f581dbd1c5cb8467f824",
      );

      expect(
        node.publicKeyHex(account: account, change: change, index: index),
        "028909436d3b2aeb4c0e06476c13c45efa6d3272d746f2a812ff38347e83ab4dc1",
      );

      expect(
        node.privateKeyHex(
            account: account, change: change, index: index, hardened: true),
        "c56e7e10b75937f3ee222dbe0a17ff14ecb3e7f5d86ac2968ed5d4419dc9ac0c",
      );

      expect(
        node.publicKeyHex(
            account: account, change: change, index: index, hardened: true),
        "030c7cc38a28f520af0ad6bb71e2a9ad912c8574316ee9818bbbcf30957eba0b10",
      );

      expect(node.address(index: 1), "1K1dFdNEGfb4K7XiyjBpBHQGfYzPpWUAWd");

      expect(node.address(index: 2, hardened: true),
          "1JCYB8XCd5JgyuSejfWvWrP4PzYEZLTAP3");
    });

    test('test btc testnet', () {
      const coin = 1;
      const account = 0;
      const change = 0;
      const index = 1024;
      final node = BIP44.fromSeed(
          "87fbb2c47e6cb3a8c5dc0eb9c6b86ac6d78c19a3a62ee6e3b59cb92fda2c9a58df77a691f450645f78ec98584edf9c7b4c25f2e414fc9f39e97ba6788f5311a0",
          coinType: coin);

      expect(
        node.privateKeyHex(),
        "fe34a8c96a96d699d753922d98a7b33d83089e1b7072a1325f67c1ddf00c5d6c",
      );

      expect(
        node.publicKeyHex(),
        "0367030aff9412b65ce6ab2d5135e222d7122010f62a6bd344f42d5a5c214e9243",
      );

      expect(
        node.privateKeyHex(hardened: true),
        "20cb0ec94fce7f55ac40ebc014fa5d592f5591a006b89e21ce9d11402dd4667c",
      );

      expect(
        node.publicKeyHex(hardened: true),
        "0240e5acc9eb9749110b8bcba0adc18a9f2fd2fbbd7078bdbe2c55093dd1a2aabe",
      );

      expect(
        node.privateKeyHex(account: account, change: change, index: index),
        "3d16a8b7942276ddd26ebfb0f6b15785f6a9f26d2e0cda142c2b0c51166337f6",
      );

      expect(
        node.publicKeyHex(account: account, change: change, index: index),
        "02cbe492dee899851da28168867fd2554a53ab439719f364117936da2e5160fd66",
      );

      expect(
        node.privateKeyHex(
            account: account, change: change, index: index, hardened: true),
        "e719b73d1dc138870ae0e828a4bdd26a454580ca8ad0661b906dba9e508455e0",
      );

      expect(
        node.publicKeyHex(
            account: account, change: change, index: index, hardened: true),
        "0222f46864b8add22bb51afedb9e929226b44a4b09df94b19a05a0905945d504ba",
      );

      expect(node.address(index: 1), "n1bk9cfBcdpkhjqasjQ3sePcf2APes2Nto");

      expect(node.address(index: 2, hardened: true),
          "miUpCLr6MsAdGbQVTrN4Ye9FP5b338DxaF");
    });
  });
}
