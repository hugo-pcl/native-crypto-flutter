// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/data_sources/session_data_source.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';

class SessionDataSourceImpl extends SessionDataSource {
  SecretKey? _sk;
  Mode? _mode = const NativeCryptoMode();

  @override
  Future<SecretKey> getSessionKey() async {
    if (_sk == null) {
      throw Exception('Session key is not ready');
    }

    return _sk!;
  }

  @override
  Future<bool> isSessionKeyReady() async => _sk != null;

  @override
  Future<void> setSessionKey(SecretKey key) async {
    _sk = key;
  }

  @override
  Future<Mode> getCurrentMode() async {
    if (_mode == null) {
      throw Exception('Mode is not set');
    }

    return _mode!;
  }

  @override
  Future<void> setCurrentMode(Mode mode) async {
    _mode = mode;
  }
}
