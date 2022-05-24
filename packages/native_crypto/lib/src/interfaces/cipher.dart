// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 24/05/2022 19:55:38
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/core/cipher_text.dart';
import 'package:native_crypto/src/utils/cipher_algorithm.dart';

/// Represents a cipher.
///
/// In cryptography, a cipher is an algorithm for performing encryption
/// or decryption - a series of well-defined steps that can
/// be followed as a procedure.
abstract class Cipher {
  /// Returns the size of a chunk of data 
  /// that can be processed by the cipher.
  static int _bytesCountPerChunk = 33554432;

  static int get bytesCountPerChunk => Cipher._bytesCountPerChunk;

  static set bytesCountPerChunk(int bytesCount) {
    _bytesCountPerChunk = bytesCount;
  }
  
  /// Returns the standard algorithm name for this cipher
  CipherAlgorithm get algorithm;


  /// Encrypts data.
  ///
  /// Takes [Uint8List] data as parameter.
  /// Returns a [CipherText].
  Future<CipherText> encrypt(Uint8List data);

  /// Decrypts cipher text.
  ///
  /// Takes [CipherText] as parameter.
  /// And returns plain text data as [Uint8List].
  Future<Uint8List> decrypt(CipherText cipherText);
}
