// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

abstract class Constants {
  /// The default chunk size in bytes used for encryption and decryption.
  static const int defaultChunkSize = 33554432;

  static const int aesGcmNonceLength = 12;
  static const int aesGcmTagLength = 16;
}
