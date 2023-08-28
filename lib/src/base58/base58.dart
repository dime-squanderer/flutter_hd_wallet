import 'dart:typed_data';

import 'package:base_x/base_x.dart';
import 'package:hex/hex.dart';

const String alphabet =
    '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
var base58 = BaseXCodec(alphabet);

String encode(Uint8List hash) {
  return base58.encode(hash);
}

String encodeHex(String hex) {
  final hash = Uint8List.fromList(HEX.decode(hex));
  return base58.encode(hash);
}

Uint8List decode(String string) {
  return base58.decode(string);
}
