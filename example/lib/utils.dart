// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:typed_data';
import 'dart:convert';

/// Contains some useful functions.
class TypeHelper {
  /// Returns bytes [Uint8List] from a [String].
  static Uint8List stringToBytes(String source) {
    var list = source.runes.toList();
    var bytes = Uint8List.fromList(list);
    return bytes;
  }

  /// Returns a [String] from bytes [Uint8List].
  static String bytesToString(Uint8List bytes) {
    var string = String.fromCharCodes(bytes);
    return string;
  }

  /// Returns a `base64` [String] from bytes [Uint8List].
  static String bytesToBase64(Uint8List bytes) {
    return base64.encode(bytes);
  }

  /// Returns a [Uint8List] from a `base64` [String].
  static Uint8List base64ToBytes(String encoded) {
    return base64.decode(encoded);
  }
}
