// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

part 'output_state.dart';

class OutputCubit extends Cubit<OutputState> {
  OutputCubit(this.loggerRepository) : super(const OutputState.empty()) {
    logSubscription = loggerRepository.streamLogs().listen((message) {
      if (message.isOk) {
        onMessage(message.ok!);
      }
    });
  }

  final LoggerRepository loggerRepository;
  late StreamSubscription<Result<Map<DateTime, LogMessage>, AppException>>
      logSubscription;

  FutureOr<void> add(LogMessage message) {
    loggerRepository.addLog(message);
  }

  FutureOr<void> clear() {
    loggerRepository.clearLog();
    emit(const OutputState.empty());
  }

  FutureOr<void> onMessage(Map<DateTime, LogMessage> entries) {
    emit(OutputState(entries: entries));
  }

  @override
  Future<void> close() {
    logSubscription.cancel();
    return super.close();
  }
}
