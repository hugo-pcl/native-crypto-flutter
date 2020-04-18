// Copyright (c) 2020
// Author: Hugo Pointcheval

class KeyException implements Exception {
  String error;
  KeyException(this.error);
}

class EncryptionException implements Exception {
  String error;
  EncryptionException(this.error);
}

class DecryptionException implements Exception {
  String error;
  DecryptionException(this.error);
}

class PlatformException implements Exception {
  String error;
  PlatformException(this.error);
}

class NotImplementedException implements Exception {
  String error;
  NotImplementedException(this.error);
}
