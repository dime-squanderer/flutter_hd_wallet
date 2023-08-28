import "dart:typed_data";

class WIF {
  int version;
  Uint8List privateKey;
  bool compressed;
  WIF(
      {required this.version,
      required this.privateKey,
      required this.compressed});
}
