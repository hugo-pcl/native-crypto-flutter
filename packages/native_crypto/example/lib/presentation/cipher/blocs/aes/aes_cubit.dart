// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/domain/entities/log_message.dart';
import 'package:native_crypto_example/domain/entities/states.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';

part 'aes_state.dart';

class AESCubit extends Cubit<AESState> {
  AESCubit({
    required this.sessionRepository,
    required this.loggerRepository,
    required this.cryptoRepository,
  }) : super(const AESState.initial());
  final SessionRepository sessionRepository;
  final LoggerRepository loggerRepository;
  final CryptoRepository cryptoRepository;

  FutureOr<void> encrypt(String message) async {
    emit(state.copyWith(state: State.loading));

    final sk = await sessionRepository.getSessionKey();

    if (sk.isErr) {
      await loggerRepository.addLog(
        const LogError('No SecretKey!\n'
            'Go in Key tab and generate or derive one.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          plainText: message.toBytes(),
          error: sk.err?.message,
        ),
      );

      return;
    }

    final result = await cryptoRepository.encrypt(message.toBytes(), sk.ok!);

    emit(
      await result.foldAsync(
        (cipherText) async {
          await loggerRepository.addLog(
            LogInfo('String successfully encrypted.\n'
                'Length: ${cipherText.length} bytes.\n'
                'Hex:\n${cipherText.toStr(to: Encoding.base16)}'),
          );
          return state.copyWith(
            state: State.success,
            plainText: message.toBytes(),
            cipherText: cipherText,
            plainTextFile: '',
            cipherTextFile: '',
          );
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during encryption.'),
          );
          return state.copyWith(
            state: State.failure,
            plainText: message.toBytes(),
            error: error.message,
          );
        },
      ),
    );

    return;
  }

  FutureOr<void> alterMemory() async {
    emit(state.copyWith(state: State.loading));

    if (state.cipherText?.isEmpty ?? true) {
      const error = 'Encrypt before decrypting!';
      await loggerRepository.addLog(
        const LogError(error),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: error,
        ),
      );

      return;
    }

    final altered = state.cipherText!;
    altered[0] += 1;

    await loggerRepository.addLog(
      const LogWarning('In memory cipher text altered.'),
    );

    emit(state.copyWith(cipherText: altered));

    return;
  }

  FutureOr<void> decryptFromMemory() async {
    emit(state.copyWith(state: State.loading));

    final sk = await sessionRepository.getSessionKey();

    if (sk.isErr) {
      await loggerRepository.addLog(
        const LogError('No SecretKey!\n'
            'Go in Key tab and generate or derive one.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: sk.err?.message,
        ),
      );

      return;
    }

    if (state.cipherText?.isEmpty ?? true) {
      const error = 'Encrypt before decrypting!';
      await loggerRepository.addLog(
        const LogError(error),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: error,
        ),
      );

      return;
    }

    final result = await cryptoRepository.decrypt(state.cipherText!, sk.ok!);

    emit(
      await result.foldAsync(
        (plainText) async {
          await loggerRepository.addLog(
            LogInfo('String successfully decrypted.\n'
                'Text:\n${plainText.toStr()}'),
          );
          return state.copyWith(
            state: State.success,
            plainText: plainText,
            plainTextFile: '',
            cipherTextFile: '',
          );
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during decryption.'),
          );
          return state.copyWith(
            state: State.failure,
            error: error.message,
          );
        },
      ),
    );

    return;
  }

  FutureOr<void> decryptFromBase16(String message) async {
    emit(state.copyWith(state: State.loading));

    final sk = await sessionRepository.getSessionKey();
    final cipherText = message.toBytes(from: Encoding.base16);

    if (sk.isErr) {
      await loggerRepository.addLog(
        const LogError('No SecretKey!\n'
            'Go in Key tab and generate or derive one.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          cipherText: cipherText,
          error: sk.err?.message,
        ),
      );

      return;
    }

    final result = await cryptoRepository.decrypt(cipherText, sk.ok!);

    emit(
      await result.foldAsync(
        (plainText) async {
          await loggerRepository.addLog(
            LogInfo('String successfully decrypted.\n'
                'Text:\n${plainText.toStr()}'),
          );
          return state.copyWith(
            state: State.success,
            plainText: plainText,
            cipherText: cipherText,
            plainTextFile: '',
            cipherTextFile: '',
          );
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during decryption.'),
          );
          return state.copyWith(
            state: State.failure,
            cipherText: cipherText,
            error: error.message,
          );
        },
      ),
    );

    return;
  }

  FutureOr<void> encryptFile() async {
    emit(state.copyWith(state: State.loading));

    final sk = await sessionRepository.getSessionKey();

    if (sk.isErr) {
      await loggerRepository.addLog(
        const LogError('No SecretKey!\n'
            'Go in Key tab and generate or derive one.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: sk.err?.message,
        ),
      );

      return;
    }

    // Pick file to encrypt
    final pickFileResult = await FilePicker.platform.pickFiles();

    if (pickFileResult == null) {
      await loggerRepository.addLog(
        const LogError('No file selected.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: 'No file selected.',
        ),
      );

      return;
    }

    final file = File(pickFileResult.files.single.path!);

    // Pick folder to store the encrypted file
    final resultFolder = await FilePicker.platform.getDirectoryPath();

    if (resultFolder == null) {
      await loggerRepository.addLog(
        const LogError('No folder selected.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: 'No folder selected.',
        ),
      );

      return;
    }

    final folder = Directory(resultFolder);

    final encryption = await cryptoRepository.encryptFile(
      file,
      folder.uri,
      sk.ok!,
    );

    emit(
      await encryption.foldAsync(
        (_) async {
          await loggerRepository.addLog(
            const LogInfo('File successfully encrypted.\n'),
          );
          return state.copyWith(
            state: State.success,
            plainTextFile: '',
            cipherTextFile: '',
          );
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during encryption.'),
          );
          return state.copyWith(
            state: State.failure,
            error: error.message,
          );
        },
      ),
    );

    return;
  }

  FutureOr<void> decryptFile() async {
    emit(state.copyWith(state: State.loading));

    final sk = await sessionRepository.getSessionKey();

    if (sk.isErr) {
      await loggerRepository.addLog(
        const LogError('No SecretKey!\n'
            'Go in Key tab and generate or derive one.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: sk.err?.message,
        ),
      );

      return;
    }

    await FilePicker.platform.clearTemporaryFiles();

    final resultPickFile = await FilePicker.platform.pickFiles();

    if (resultPickFile == null) {
      await loggerRepository.addLog(
        const LogError('No file selected.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: 'No file selected.',
        ),
      );

      return;
    }

    final file = File(resultPickFile.files.single.path!);

    // Pick folder to store the encrypted file
    final resultFolder = await FilePicker.platform.getDirectoryPath();

    if (resultFolder == null) {
      await loggerRepository.addLog(
        const LogError('No folder selected.'),
      );
      emit(
        state.copyWith(
          state: State.failure,
          error: 'No folder selected.',
        ),
      );

      return;
    }

    final folder = Directory(resultFolder);

    final decryption =
        await cryptoRepository.decryptFile(file, folder.uri, sk.ok!);

    emit(
      await decryption.foldAsync(
        (_) async {
          await loggerRepository.addLog(
            const LogInfo('File successfully decrypted.\n'),
          );
          return state.copyWith(
            state: State.success,
            plainTextFile: '',
            cipherTextFile: '',
          );
        },
        (error) async {
          await loggerRepository.addLog(
            LogError(error.message ?? 'Error during decryption.'),
          );
          return state.copyWith(
            state: State.failure,
            error: error.message,
          );
        },
      ),
    );

    return;
  }
}
