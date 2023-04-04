// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:native_crypto_platform_interface/src/implementations/basic_message_channel_native_crypto.dart';
import 'package:native_crypto_platform_interface/src/interface/native_crypto_platform.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class ImplementsNativeCryptoPlatform
    // ignore: prefer_mixin
    with
        Mock
    implements
        NativeCryptoPlatform {}

class ExtendsNativeCryptoPlatform extends NativeCryptoPlatform {}

class NativeCryptoMockPlatform extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        NativeCryptoPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$NativeCryptoPlatform', () {
    // should allow read of default app from native
    test('Can be extended', () {
      NativeCryptoPlatform.instance = ExtendsNativeCryptoPlatform();
    });

    test('Cannot be implemented with `implements`', () {
      expect(
        () {
          NativeCryptoPlatform.instance = ImplementsNativeCryptoPlatform();
        },
        throwsA(anything),
      );
    });

    test('Can be mocked with `implements`', () {
      final NativeCryptoMockPlatform mock = NativeCryptoMockPlatform();
      NativeCryptoPlatform.instance = mock;
    });

    test('Can set with $BasicMessageChannelNativeCrypto', () {
      final BasicMessageChannelNativeCrypto pigeon =
          BasicMessageChannelNativeCrypto();
      NativeCryptoPlatform.instance = pigeon;
    });
  });
}
