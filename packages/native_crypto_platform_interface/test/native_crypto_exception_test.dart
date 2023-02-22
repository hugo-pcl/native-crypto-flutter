// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:native_crypto_platform_interface/src/core/enums/exception_code.dart';
import 'package:native_crypto_platform_interface/src/core/exceptions/exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$NativeCryptoException', () {
    test('should return a formatted message with only code', () async {
      const e = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
      );

      expect(e.toString(), '[NativeCrypto/unknown_error]');
    });

    test('should return a formatted message', () async {
      const e = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
        message: 'foo',
      );

      expect(e.toString(), '[NativeCrypto/unknown_error] foo');
    });

    test('should return a formatted message with a stack trace', () async {
      const e = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
        message: 'foo',
      );

      expect(e.toString(), '[NativeCrypto/unknown_error] foo');
    });

    test('should return a formatted message with a stack trace', () async {
      final e = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
        message: 'foo',
        stackTrace: StackTrace.current,
      );

      // Anything with a stack trace adds 2 blanks lines following the message.
      expect(e.toString(), startsWith('[NativeCrypto/unknown_error] foo\n\n'));
    });

    test('should override the == operator', () async {
      const e1 = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
        message: 'foo',
      );

      const e2 = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
        message: 'foo',
      );

      const e3 = NativeCryptoException(
        code: NativeCryptoExceptionCode.unknownError,
        message: 'foo',
      );

      expect(e1 == e2, true);
      expect(e1 != e3, false);
    });
  });
}
