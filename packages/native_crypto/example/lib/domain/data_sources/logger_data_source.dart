// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

abstract class LoggerDataSource extends BaseDataSource {
  Future<void> addLog(LogMessage message);
  Future<void> clearLog();
  Future<Map<DateTime, LogMessage>> getLogs();
  Stream<Map<DateTime, LogMessage>> streamLogs();
}
