// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: exception.dart
// Created Date: 24/05/2022 18:54:48
// Last Modified: 25/05/2022 10:43:29
// -----
// Copyright (c) 2022

import 'dart:developer';

import 'package:flutter/services.dart';

class NativeCryptoException implements Exception {
  const NativeCryptoException({
    this.message,
    String? code,
    this.stackTrace,
    // ignore: unnecessary_this
  }) : this.code = code ?? 'unknown';

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  @override
  String toString() {
    String output = '[NativeException/$code] $message';

    if (stackTrace != null) {
      output += '\n\n${stackTrace.toString()}';
    }

    return output;
  }

  /// Catches a [PlatformException] and returns an [Exception].
  ///
  /// If the [Exception] is a [PlatformException],
  /// a [NativeCryptoException] is returned.
  static Never convertPlatformException(
    Object exception,
    StackTrace stackTrace,
  ) {
    log(exception.toString());
    if (exception is! Exception || exception is! PlatformException) {
      Error.throwWithStackTrace(exception, stackTrace);
    }

    Error.throwWithStackTrace(
      NativeCryptoException.fromPlatformException(exception, stackTrace),
      stackTrace,
    );
  }

  /// Converts a [PlatformException] into a [NativeCryptoException].
  ///
  /// A [PlatformException] can only be converted to a [NativeCryptoException]
  /// if the `details` of the exception exist.
  factory NativeCryptoException.fromPlatformException(
    PlatformException platformException,
    StackTrace stackTrace,
  ) {
    final Map<String, String>? details = platformException.details != null
        ? Map<String, String>.from(
            platformException.details as Map<String, String>,
          )
        : null;

    String code = 'unknown';
    String message = platformException.message ?? '';

    if (details != null) {
      code = details['code'] ?? code;
      message = details['message'] ?? message;
    }

    return NativeCryptoException(
      message: message,
      code: code,
      stackTrace: stackTrace,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NativeCryptoException &&
        other.message == message &&
        other.code == code &&
        other.stackTrace == stackTrace;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => message.hashCode ^ code.hashCode ^ stackTrace.hashCode;
}

class KeyException extends NativeCryptoException {
  const KeyException({
    super.message,
    super.code,
    super.stackTrace,
  });
}

class KeyDerivationException extends NativeCryptoException {
  const KeyDerivationException({
    super.message,
    super.code,
    super.stackTrace,
  });
}

class CipherInitException extends NativeCryptoException {
  const CipherInitException({
    super.message,
    super.code,
    super.stackTrace,
  });
}

class EncryptionException extends NativeCryptoException {
  const EncryptionException({
    super.message,
    super.code,
    super.stackTrace,
  });
}

class DecryptionException extends NativeCryptoException {
  const DecryptionException({
    super.message,
    super.code,
    super.stackTrace,
  });
}

class NotImplementedException extends NativeCryptoException {
  const NotImplementedException({
    super.message,
    super.code,
    super.stackTrace,
  });
}
