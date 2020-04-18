// Copyright (c) 2020
// Author: Hugo Pointcheval

class KeyException implements Exception {
  String message;
  KeyException(this.message);
}

class EncryptionException implements Exception {
  String message;
  EncryptionException(this.message);
}

class DecryptionException implements Exception {
  String message;
  DecryptionException(this.message);
}

class NotImplementedException implements Exception {
  String message;
  NotImplementedException(this.message);
}
