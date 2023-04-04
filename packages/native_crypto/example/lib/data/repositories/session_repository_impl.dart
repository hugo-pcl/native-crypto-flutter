// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/data_sources/session_data_source.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

class SessionRepositoryImpl extends SessionRepository {
  SessionRepositoryImpl({
    required this.sessionDataSource,
  });
  SessionDataSource sessionDataSource;

  @override
  FutureOrResult<SecretKey> getSessionKey() => Result.tryCatchAsync(
        () async => sessionDataSource.getSessionKey(),
        (error) => ClientException(error.toString()),
      );

  @override
  FutureOrResult<bool> isSessionKeyReady() => Result.tryCatchAsync(
        () async => sessionDataSource.isSessionKeyReady(),
        (error) => ClientException(error.toString()),
      );

  @override
  FutureOrResult<void> setSessionKey(SecretKey key) => Result.tryCatchAsync(
        () async => sessionDataSource.setSessionKey(key),
        (error) => ClientException(error.toString()),
      );

  @override
  FutureOrResult<Mode> getCurrentMode() => Result.tryCatchAsync(
        () async => sessionDataSource.getCurrentMode(),
        (error) => ClientException(error.toString()),
      );

  @override
  FutureOrResult<void> setCurrentMode(Mode mode) => Result.tryCatchAsync(
        () async => sessionDataSource.setCurrentMode(mode),
        (error) => ClientException(error.toString()),
      );
}
