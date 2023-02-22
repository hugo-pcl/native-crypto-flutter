// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:native_crypto_platform_interface/src/core/enums/exception_code.dart';

/// An exception thrown by the native crypto plugin.
class NativeCryptoException extends Equatable implements Exception {
  /// Creates a new [NativeCryptoException].
  const NativeCryptoException({
    required this.code,
    this.message,
    this.stackTrace,
  });

  /// Creates a new [NativeCryptoException] from a [PlatformException].
  factory NativeCryptoException.fromPlatformException(
    PlatformException platformException,
    StackTrace stackTrace,
  ) {
    final Map<String, String>? details = platformException.details != null
        ? Map<String, String>.from(
            platformException.details as Map<String, String>,
          )
        : null;

    String code = platformException.code.split('(').first;
    String message = platformException.message ?? '';

    if (details != null) {
      code = details['code'] ?? code;
      message = details['message'] ?? message;
    }

    return NativeCryptoException(
      code: NativeCryptoExceptionCode.from(code),
      message: message,
      stackTrace: stackTrace,
    );
  }

  /// The standardised error code.
  final NativeCryptoExceptionCode code;

  /// The long form message of the exception.
  final String? message;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  static Never convertPlatformException(
    Object exception,
    StackTrace stackTrace,
  ) {
    // If the exception is not a PlatformException, throw it as is.
    if (exception is! Exception || exception is! PlatformException) {
      Error.throwWithStackTrace(exception, stackTrace);
    }

    // Otherwise, throw a NativeCryptoException.
    Error.throwWithStackTrace(
      NativeCryptoException.fromPlatformException(exception, stackTrace),
      stackTrace,
    );
  }

  NativeCryptoException copyWith({
    NativeCryptoExceptionCode? code,
    String? message,
    StackTrace? stackTrace,
  }) =>
      NativeCryptoException(
        code: code ?? this.code,
        message: message ?? this.message,
        stackTrace: stackTrace ?? this.stackTrace,
      );

  @override
  String toString() {
    final output = StringBuffer('[NativeCrypto/$code]');

    if (message != null) {
      output.write(' $message');
    }

    if (stackTrace != null) {
      output.write('\n\n$stackTrace');
    }

    return output.toString();
  }

  @override
  List<Object?> get props => [code, message, stackTrace];
}
