// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: exceptions.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 23/05/2022 21:51:55
// -----
// Copyright (c) 2021

class NativeCryptoException implements Exception {
  final String message;
  const NativeCryptoException(this.message);
}

class UtilsException extends NativeCryptoException {
  UtilsException(String message) : super(message);
}

class KeyException extends NativeCryptoException {
  KeyException(String message) : super(message);
}

class KeyDerivationException extends NativeCryptoException {
  KeyDerivationException(String message) : super(message);
}

class CipherInitException extends NativeCryptoException {
  CipherInitException(String message) : super(message);
}

class EncryptionException extends NativeCryptoException {
  EncryptionException(String message) : super(message);
}

class DecryptionException extends NativeCryptoException {
  DecryptionException(String message) : super(message);
}

class NotImplementedException extends NativeCryptoException {
  NotImplementedException(String message) : super(message);
}
