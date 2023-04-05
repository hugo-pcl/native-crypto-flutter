// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:native_crypto_example/domain/entities/states.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';

part 'benchmark_state.dart';

class BenchmarkCubit extends Cubit<BenchmarkState> {
  BenchmarkCubit({
    required this.sessionRepository,
    required this.loggerRepository,
    required this.cryptoRepository,
  }) : super(const BenchmarkState.initial());
  final SessionRepository sessionRepository;
  final LoggerRepository loggerRepository;
  final CryptoRepository cryptoRepository;

  List<int> testedSizes = [
    2097152,
    6291456,
    10485760,
    14680064,
    18874368,
    23068672,
    27262976,
    31457280,
    35651584,
    39845888,
    44040192,
    48234496,
    52428800,
  ];

  FutureOr<void> launchBenchmark() async {
    emit(const BenchmarkState.loading());

    final sk = await sessionRepository.getSessionKey();

    if (sk.isErr) {
      await loggerRepository.addLog(
        const LogError('No SecretKey!\n'
            'Go in Key tab and generate or derive one.'),
      );
      emit(
        BenchmarkState.failure(
          sk.err?.message,
        ),
      );
    }

    int run = 0;
    final csv = StringBuffer(
      'Run;Size (B);Encryption Time (ms);Decryption Time (ms)\n',
    );
    for (final size in testedSizes) {
      run++;
      final StringBuffer csvLine = StringBuffer();
      final dummyBytes = Uint8List(size);
      csvLine.write('$run;$size;');

      // Encryption
      final beforeEncryption = DateTime.now();

      final encryptedBigFileResult = await cryptoRepository.encrypt(
        dummyBytes,
        sk.ok!,
      );

      final afterEncryption = DateTime.now();

      final benchmarkEncryption = afterEncryption.millisecondsSinceEpoch -
          beforeEncryption.millisecondsSinceEpoch;

      await loggerRepository.addLog(
        LogInfo(
          '[Benchmark] ${size ~/ 1000000}MB => Encryption took $benchmarkEncryption ms',
        ),
      );

      csvLine.write('$benchmarkEncryption');

      if (encryptedBigFileResult.isErr) {
        await loggerRepository.addLog(
          LogError(
            'Encryption failed: ${encryptedBigFileResult.err?.message}',
          ),
        );
        emit(
          BenchmarkState.failure(
            encryptedBigFileResult.err?.message,
          ),
        );
        return;
      }

      // Decryption
      final beforeDecryption = DateTime.now();
      await cryptoRepository.decrypt(
        encryptedBigFileResult.ok!,
        sk.ok!,
      );
      final afterDecryption = DateTime.now();
      final benchmarkDecryption = afterDecryption.millisecondsSinceEpoch -
          beforeDecryption.millisecondsSinceEpoch;
      await loggerRepository.addLog(
        LogInfo(
          '[Benchmark] ${size ~/ 1000000}MB => Decryption took $benchmarkDecryption ms',
        ),
      );

      csvLine.write(';$benchmarkDecryption');
      csv.writeln(csvLine);
    }
    debugPrint(csv.toString());
    emit(
      const BenchmarkState.success(),
    );

    return;
  }
}
