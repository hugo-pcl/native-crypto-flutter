// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: exception.dart
// Created Date: 24/05/2022 18:54:48
// Last Modified: 24/05/2022 18:58:39
// -----
// Copyright (c) 2022

import 'package:flutter/services.dart';

class NativeCryptoException implements Exception {
  final String message;
  const NativeCryptoException(this.message);
}

/// Catches a [PlatformException] and returns an [Exception].
///
/// If the [Exception] is a [PlatformException],
/// a [NativeCryptoException] is returned.
Never convertPlatformException(Object exception, StackTrace stackTrace) {
  if (exception is! Exception || exception is! PlatformException) {
    Error.throwWithStackTrace(exception, stackTrace);
  }

  Error.throwWithStackTrace(
    platformExceptionToNativeCryptoException(exception, stackTrace),
    stackTrace,
  );
}

/// Converts a [PlatformException] into a [NativeCryptoException].
///
/// A [PlatformException] can only be converted to a [NativeCryptoException]
/// if the `details` of the exception exist.
NativeCryptoException platformExceptionToNativeCryptoException(
  PlatformException platformException,
  StackTrace stackTrace,
) {
  final Map<String, String>? details = platformException.details != null
      ? Map<String, String>.from(
          platformException.details as Map<String, String>,
        )
      : null;

  String message = platformException.message ?? '';

  if (details != null) {
    message = details['message'] ?? message;
  }

  return NativeCryptoException(message);
}
