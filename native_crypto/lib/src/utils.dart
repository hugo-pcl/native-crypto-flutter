// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: utils.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 27/12/2021 22:04:07
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'cipher.dart';
import 'exceptions.dart';
import 'hasher.dart';
import 'keyderivation.dart';

class Utils {
  /// Returns enum value to string, without the enum name
  static String enumToStr(dynamic enumValue) {
    return enumValue.toString().split('.').last;
  }

  /// Returns enum list as string list
  static List<String> enumToList<T>(List<T> enumValues) {
    List<String> _res = [];
    for (T enumValue in enumValues) {
      _res.add(enumToStr(enumValue));
    }
    
    return _res;
  }

  /// Returns enum from string
  static T strToEnum<T>(String str, List<T> enumValues) {
    for (T enumValue in enumValues) {
      if (enumToStr(enumValue) == str) {
        return enumValue;
      }
    }
    throw UtilsException('Invalid enum value: $str');
  }

  /// Returns [HashAlgorithm] from his name.
  static HashAlgorithm getHashAlgorithm(String algorithm) {
    return strToEnum<HashAlgorithm>(algorithm.toLowerCase(), HashAlgorithm.values);
  }

  /// Returns all available [HashAlgorithm] as String list
  static List<String> getAvailableHashAlgorithms() {
    return enumToList<HashAlgorithm>(HashAlgorithm.values);
  }

  /// Returns [KdfAlgorithm] from his name.
  static KdfAlgorithm getKdfAlgorithm(String algorithm) {
    return strToEnum<KdfAlgorithm>(algorithm.toLowerCase(), KdfAlgorithm.values);
  }

  /// Returns all available [KdfAlgorithm] as String list
  static List<String> getAvailableKdfAlgorithms() {
    return enumToList<KdfAlgorithm>(KdfAlgorithm.values);
  }

  /// Returns [CipherAlgorithm] from his name.
  static CipherAlgorithm getCipherAlgorithm(String algorithm) {
    return strToEnum<CipherAlgorithm>(algorithm.toLowerCase(), CipherAlgorithm.values);
  }

  /// Returns all available [CipherAlgorithm] as String list
  static List<String> getAvailableCipherAlgorithms() {
    return enumToList<CipherAlgorithm>(CipherAlgorithm.values);
  }

 static  Uint8List decodeHexString(String input) {
    assert(input.length % 2 == 0, 'Input needs to be an even length.');

    return Uint8List.fromList(
      List.generate(
        input.length ~/ 2,
        (i) => int.parse(input.substring(i * 2, (i * 2) + 2), radix: 16),
      ).toList(),
    );
  }
}
