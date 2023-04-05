// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/core/typography.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';
import 'package:native_crypto_example/presentation/cipher/blocs/aes/aes_cubit.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/button_state_management.dart';
import 'package:native_crypto_example/presentation/output/widgets/logs.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class AESStateManagement extends CubitScreen<AESCubit, AESState> {
  AESStateManagement({super.key});

  final TextEditingController _plainTextTextController = TextEditingController()
    ..text = 'abc';

  final TextEditingController _cipherTextTextController =
      TextEditingController();

  @override
  AESCubit create(BuildContext context) => AESCubit(
        sessionRepository: repo<SessionRepository>(context),
        loggerRepository: repo<LoggerRepository>(context),
        cryptoRepository: repo<CryptoRepository>(context),
      );

  @override
  Widget onBuild(BuildContext context, AESState state) => ListView(
        children: [
          const Logs(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'AES256-GCM',
              style: AppTypography.title,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '''AES is a symmetric-key encryption algorithm that is widely used to encrypt sensitive data. It works by encrypting plaintext (the original data) using a secret key and a set of predefined mathematical operations (known as a cipher). The result is ciphertext (the encrypted data) that can only be decrypted and read by someone who has access to the secret key.\nGCM is a mode of operation for AES that provides both confidentiality and authenticity. It works by combining a block cipher (such as AES) with a Galois Field (a mathematical structure used to define a specific type of encryption) and a Counter (a value that is incremented for each block of data that is processed).''',
              style: AppTypography.body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _plainTextTextController,
              decoration: const InputDecoration(
                hintText: 'PlainText',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Encrypt',
              onPressed: () =>
                  bloc(context).encrypt(_plainTextTextController.text),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Alter',
              onPressed: () => bloc(context).alterMemory(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Decrypt',
              onPressed: () => bloc(context).decryptFromMemory(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'File',
              style: AppTypography.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Encrypt file',
              onPressed: () => bloc(context).encryptFile(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Decrypt file',
              onPressed: () => bloc(context).decryptFile(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'External CipherText',
              style: AppTypography.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _cipherTextTextController,
              decoration: const InputDecoration(
                hintText: 'Base16 CipherText',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Decrypt',
              onPressed: () => bloc(context)
                  .decryptFromBase16(_cipherTextTextController.text),
            ),
          ),
        ],
      );
}
