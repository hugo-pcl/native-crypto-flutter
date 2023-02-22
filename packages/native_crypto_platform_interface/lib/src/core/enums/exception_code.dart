// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

enum NativeCryptoExceptionCode {
  /// The method is not implemented on the platform side.
  platformMethodNotImplemented,

  /// Platform returned invalid data.
  /// Can be null, empty, or not the expected type.
  platformReturnedInvalidData, // TODO(hpcl): remove this

  /// The platforms returned null.
  nullError,

  /// The algorithm is not supported.
  algorithmNotSupported,

  /// The key is not valid. Like a bad length or format.
  invalidKey,

  /// The data is not valid.
  invalidData,

  /// The parameters are not valid. Like an invalid IV.
  invalidParameters,

  /// Authentication failed. Like a bad MAC or tag.
  authenticationError,

  /// An I/O error occurred.
  ioError,

  /// Key derivation failed.
  keyDerivationError,

  /// Channel error. Like a bad channel or a bad message.
  channelError,

  /// An unknown error occurred.
  unknownError;

  /// Returns code of the [NativeCryptoExceptionCode].
  /// ```dart
  /// print(NativeCryptoExceptionCode.platformMethodNotImplemented.code)
  /// // => platform_method_not_implemented
  /// ```
  String get code {
    switch (name.length) {
      case 0:
        return name;
      case 1:
        return name.toLowerCase();
      default:
        return name
            .splitMapJoin(
              RegExp('[A-Z]'),
              onMatch: (m) => ' ${m[0]}',
              onNonMatch: (n) => n,
            )
            .trim()
            .splitMapJoin(
              RegExp(r'\s+|-+|_+|\.+'),
              onMatch: (m) => '_',
              onNonMatch: (n) => n.toLowerCase(),
            );
    }
  }

  /// Returns the [NativeCryptoExceptionCode] from the given [code].
  static NativeCryptoExceptionCode from(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    return unknownError;
  }

  @override
  String toString() => code;
}
