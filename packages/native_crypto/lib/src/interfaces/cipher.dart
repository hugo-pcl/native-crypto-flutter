// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: cipher.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 26/05/2022 21:21:07
// -----
// Copyright (c) 2021

import 'dart:typed_data';

import 'package:native_crypto/src/core/cipher_text_wrapper.dart';
import 'package:native_crypto/src/utils/cipher_algorithm.dart';

/// Represents a cipher in NativeCrypto.
///
/// In cryptography, a [Cipher] is an algorithm for performing encryption
/// or decryption - a series of well-defined steps that can
/// be followed as a procedure.
/// 
/// This interface is implemented by all the ciphers in NativeCrypto.
abstract class Cipher {
  static const int _bytesCountPerChunkDefault = 33554432;
  static int _bytesCountPerChunk = _bytesCountPerChunkDefault;

  /// Returns the default number of bytes per chunk.
  static int get defaultBytesCountPerChunk => _bytesCountPerChunkDefault;

  /// Returns the size of a chunk of data 
  /// that can be processed by the [Cipher].
  static int get bytesCountPerChunk => Cipher._bytesCountPerChunk;

  /// Sets the size of a chunk of data
  /// that can be processed by the [Cipher].
  static set bytesCountPerChunk(int bytesCount) {
    _bytesCountPerChunk = bytesCount;
  }
  
  /// Returns the standard algorithm for this [Cipher].
  CipherAlgorithm get algorithm;


  /// Encrypts the [data].
  ///
  /// Takes [Uint8List] data as parameter.
  /// Returns a [CipherTextWrapper].
  Future<CipherTextWrapper> encrypt(Uint8List data);

  /// Decrypts the [cipherText]
  ///
  /// Takes [CipherTextWrapper] as parameter.
  /// And returns plain text data as [Uint8List].
  Future<Uint8List> decrypt(CipherTextWrapper cipherText);
}
