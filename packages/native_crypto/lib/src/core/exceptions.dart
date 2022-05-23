// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: exceptions.dart
// Created Date: 16/12/2021 16:28:00
// Last Modified: 23/05/2022 22:30:27
// -----
// Copyright (c) 2021

class NativeCryptoException implements Exception {
  final String message;
  const NativeCryptoException(this.message);
}

class UtilsException extends NativeCryptoException {
  UtilsException(super.message);
}

class KeyException extends NativeCryptoException {
  KeyException(super.message);
}

class KeyDerivationException extends NativeCryptoException {
  KeyDerivationException(super.message);
}

class CipherInitException extends NativeCryptoException {
  CipherInitException(super.message);
}

class EncryptionException extends NativeCryptoException {
  EncryptionException(super.message);
}

class DecryptionException extends NativeCryptoException {
  DecryptionException(super.message);
}

class NotImplementedException extends NativeCryptoException {
  NotImplementedException(super.message);
}
