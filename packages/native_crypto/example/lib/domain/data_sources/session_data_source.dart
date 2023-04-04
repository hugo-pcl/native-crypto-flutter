// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

abstract class SessionDataSource extends BaseDataSource {
  Future<void> setSessionKey(SecretKey key);
  Future<bool> isSessionKeyReady();
  Future<SecretKey> getSessionKey();
  Future<Mode> getCurrentMode();
  Future<void> setCurrentMode(Mode mode);
}
