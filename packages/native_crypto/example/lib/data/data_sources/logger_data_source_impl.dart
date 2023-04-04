// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:native_crypto_example/domain/data_sources/logger_data_source.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';

class LoggerDataSourceImpl extends LoggerDataSource {
  final Map<DateTime, LogMessage> _logs = {};
  final StreamController<Map<DateTime, LogMessage>> _streamController =
      StreamController.broadcast();

  @override
  Future<void> addLog(LogMessage message) async {
    _logs[DateTime.now()] = message;
    _streamController.add(Map.from(_logs));
  }

  @override
  Future<void> clearLog() async {
    _logs.clear();
    _streamController.add(Map.from(_logs));
  }

  @override
  Future<Map<DateTime, LogMessage>> getLogs() async => _logs;

  @override
  Stream<Map<DateTime, LogMessage>> streamLogs() => _streamController.stream;
}
