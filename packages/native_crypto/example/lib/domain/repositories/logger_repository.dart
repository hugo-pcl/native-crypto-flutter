// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: logger_repository.dart
// Created Date: 09/01/2023 22:12:56
// Last Modified: 09/01/2023 23:03:51
// -----
// Copyright (c) 2023

import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

abstract class LoggerRepository extends BaseRepository {
  FutureOrResult<void> addLog(LogMessage message);
  FutureOrResult<void> clearLog();
  FutureOrResult<Map<DateTime, LogMessage>> getLogs();
  StreamResult<Map<DateTime, LogMessage>> streamLogs();
}
