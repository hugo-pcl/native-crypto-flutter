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

part 'key_derivation_state.dart';

class KeyDerivationCubit extends Cubit<KeyDerivationState> {
  KeyDerivationCubit({
    required this.sessionRepository,
    required this.loggerRepository,
    required this.cryptoRepository,
  }) : super(const KeyDerivationState.initial());
  final SessionRepository sessionRepository;
  final LoggerRepository loggerRepository;
  final CryptoRepository cryptoRepository;

  FutureOr<void> generate() async {
    emit(const KeyDerivationState.loading());
    final result = await cryptoRepository.generateSecureRandom(32);

    emit(
      await result.foldAsync(
        (key) async {
          await sessionRepository.setSessionKey(key);
          await loggerRepository.addLog(
            LogInfo('SecretKey successfully generated.\n'
                'Length: ${key.bytes.length} bytes.\n'
                'Hex:\n${key.base16}'),
          );
          return KeyDerivationState.success(key.bytes);
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during key generation.'),
          );
          return KeyDerivationState.failure(error.message);
        },
      ),
    );

    return;
  }

  FutureOr<void> pbkdf2(String password) async {
    emit(const KeyDerivationState.loading());
    if (password.isEmpty) {
      const error = 'Password is empty';
      await loggerRepository.addLog(
        const LogError(error),
      );
      emit(const KeyDerivationState.failure(error));
    }
    final result =
        await cryptoRepository.deriveKeyFromPassword(password, salt: 'salt');

    emit(
      await result.foldAsync(
        (key) async {
          await sessionRepository.setSessionKey(key);
          await loggerRepository.addLog(
            LogInfo('SecretKey successfully derivated from $password.\n'
                'Length: ${key.bytes.length} bytes.\n'
                'Hex:\n${key.base16}'),
          );
          return KeyDerivationState.success(key.bytes);
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during key derivation.'),
          );
          return KeyDerivationState.failure(error.message);
        },
      ),
    );

    return;
  }

  FutureOr<void> getSessionKey() async {
    emit(const KeyDerivationState.loading());
    final sk = await sessionRepository.getSessionKey();
    emit(
      await sk.foldAsync((key) async {
        await loggerRepository.addLog(
          LogInfo('Session key successfully retreived.\n'
              'Length: ${key.bytes.length} bytes.\n'
              'Hex:\n${key.base16}'),
        );
        return KeyDerivationState.success(key.bytes);
      }, (error) async {
        await loggerRepository.addLog(
          LogError(error.message ?? 'Error during key retrieving.'),
        );
        return KeyDerivationState.failure(error.message);
      }),
    );

    return;
  }
}
