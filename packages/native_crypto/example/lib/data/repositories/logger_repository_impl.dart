// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto_example/domain/data_sources/logger_data_source.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

class LoggerRepositoryImpl extends LoggerRepository {
  LoggerRepositoryImpl({
    required this.loggerDataSource,
  });

  final LoggerDataSource loggerDataSource;

  @override
  FutureOrResult<void> addLog(LogMessage message) => Result.tryCatchAsync(
        () async => loggerDataSource.addLog(message),
        (error) => ClientException(error.toString()),
      );

  @override
  FutureOrResult<void> clearLog() => Result.tryCatchAsync(
        () async => loggerDataSource.clearLog(),
        (error) => ClientException(error.toString()),
      );

  @override
  FutureOrResult<Map<DateTime, LogMessage>> getLogs() => Result.tryCatchAsync(
        () async => loggerDataSource.getLogs(),
        (error) => ClientException(error.toString()),
      );

  @override
  StreamResult<Map<DateTime, LogMessage>> streamLogs() =>
      loggerDataSource.streamLogs().map(Ok.new);
}
