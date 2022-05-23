// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: exceptions.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 27/12/2021 23:28:31
// -----
// Copyright (c) 2021

class NativeCryptoException implements Exception {
  String message;
  NativeCryptoException(this.message);
}

class UtilsException extends NativeCryptoException {
  UtilsException(message) : super(message);
}

class KeyException extends NativeCryptoException {
  KeyException(message) : super(message);
}

class KeyDerivationException extends NativeCryptoException {
  KeyDerivationException(message) : super(message);
}

class CipherInitException extends NativeCryptoException {
  CipherInitException(message) : super(message);
}

class EncryptionException extends NativeCryptoException {
  EncryptionException(message) : super(message);
}

class DecryptionException extends NativeCryptoException {
  DecryptionException(message) : super(message);
}

class NotImplementedException extends NativeCryptoException {
  NotImplementedException(message) : super(message);
}
