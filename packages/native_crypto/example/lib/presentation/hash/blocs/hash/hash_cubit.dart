// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:native_crypto_example/domain/entities/states.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';

part 'hash_state.dart';

class HashCubit extends Cubit<HashState> {
  HashCubit({
    required this.loggerRepository,
    required this.cryptoRepository,
  }) : super(const HashState.initial());

  final LoggerRepository loggerRepository;
  final CryptoRepository cryptoRepository;

  FutureOr<void> hash(Hash hasher, String message) async {
    emit(const HashState.loading());
    final result = await cryptoRepository.hash(hasher, message.toBytes());

    emit(
      await result.foldAsync(
        (digest) async {
          await loggerRepository.addLog(
            LogInfo('Hash $message using ${hasher.algorithm.name}.\n'
                'Length: ${digest.length} bytes.\n'
                'Hex:\n${digest.toStr(to: Encoding.base16)}'),
          );
          return HashState.success(digest);
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during digest.'),
          );
          return HashState.failure(error.message);
        },
      ),
    );

    return;
  }
}
