// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// An encoding used to convert a byte array to a string and vice-versa.
enum Encoding {
  /// UTF-8 encoding, as defined by the Unicode standard.
  utf8,
  /// UTF-16 encoding, as defined by the Unicode standard.
  utf16,
  /// Base64 encoding, as defined by RFC 4648.
  base64,
  /// Hexadecimal encoding.
  base16,
}
