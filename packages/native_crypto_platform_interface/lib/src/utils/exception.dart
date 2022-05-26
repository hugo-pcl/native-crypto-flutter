// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: exception.dart
// Created Date: 24/05/2022 18:54:48
// Last Modified: 26/05/2022 15:36:56
// -----
// Copyright (c) 2022

// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:flutter/services.dart';

enum NativeCryptoExceptionCode {
  unknown,
  not_implemented,
  invalid_argument,
  invalid_key,
  invalid_key_length,
  invalid_algorithm,
  invalid_padding,
  invalid_mode,
  invalid_cipher,
  invalid_data,
  platform_not_supported,
  platform_returned_invalid_data,
  platform_returned_empty_data,
  platform_returned_null;

  String get code => toString().split('.').last.toLowerCase();
}

class NativeCryptoException implements Exception {
  NativeCryptoException({
    this.message,
    String? code,
    this.stackTrace,
  }) : code = code ?? NativeCryptoExceptionCode.unknown.code;

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

    String code = NativeCryptoExceptionCode.unknown.code;
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
