import 'package:flutter_test/flutter_test.dart';

import 'package:hd_wallet/src/bip44/bip44.dart';

void main() {
  test('Bip44 test', () {
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
}
