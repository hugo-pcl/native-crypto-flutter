// Copyright (c) 2020
// Author: Hugo Pointcheval

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

class KeyGenerationException extends NativeCryptoException {
  KeyGenerationException(message) : super(message);
}

class KeyPairGenerationException extends NativeCryptoException {
  KeyPairGenerationException(message) : super(message);
}

class KeyDerivationException extends NativeCryptoException {
  KeyDerivationException(message) : super(message);
}

class CipherInitException extends NativeCryptoException {
  CipherInitException(message) : super(message);
}

class KemInitException extends NativeCryptoException {
  KemInitException(message) : super(message);
}

class DigestInitException extends NativeCryptoException {
  DigestInitException(message) : super(message);
}

class DigestException extends NativeCryptoException {
  DigestException(message) : super(message);
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
