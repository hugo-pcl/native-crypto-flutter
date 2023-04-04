// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: session_repository.dart
// Created Date: 08/01/2023 17:35:46
// Last Modified: 09/01/2023 22:13:21
// -----
// Copyright (c) 2023

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

abstract class SessionRepository extends BaseRepository {
  FutureOrResult<void> setSessionKey(SecretKey key);
  FutureOrResult<bool> isSessionKeyReady();
  FutureOrResult<SecretKey> getSessionKey();
  FutureOrResult<Mode> getCurrentMode();
  FutureOrResult<void> setCurrentMode(Mode mode);
}
