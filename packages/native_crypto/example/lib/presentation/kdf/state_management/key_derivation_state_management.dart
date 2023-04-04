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
import 'package:native_crypto_example/presentation/home/state_management/widgets/button_state_management.dart';
import 'package:native_crypto_example/presentation/kdf/blocs/key_derivation/key_derivation_cubit.dart';
import 'package:native_crypto_example/presentation/output/widgets/logs.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class KeyDerivationStateManagement
    extends CubitScreen<KeyDerivationCubit, KeyDerivationState> {
  KeyDerivationStateManagement({super.key});

  final TextEditingController _pwdTextController = TextEditingController()
    ..text = 'password';

  @override
  KeyDerivationCubit create(BuildContext context) => KeyDerivationCubit(
        sessionRepository: repo<SessionRepository>(context),
        loggerRepository: repo<LoggerRepository>(context),
        cryptoRepository: repo<CryptoRepository>(context),
      );

  @override
  Widget onBuild(BuildContext context, KeyDerivationState state) => ListView(
        children: [
          const Logs(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Random secret key',
              style: AppTypography.title,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '''A secret key is a piece of information that is used to encrypt and decrypt messages. In symmetric-key encryption, the same secret key is used for both encrypting the original data and for decrypting the encrypted data. The key is kept secret so that only authorized parties can read the encrypted messages.''',
              style: AppTypography.body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Generate secret key',
              onPressed: () => bloc(context).generate(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'PBKDF2',
              style: AppTypography.title,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '''PBKDF2 (Password-Based Key Derivation Function 2) is a key derivation function that is designed to be computationally expensive and memory-intensive, in order to slow down the process of guessing a password. This makes it more difficult for an attacker to guess a password by using a brute-force attack, which involves trying every possible combination of characters until the correct password is found.''',
              style: AppTypography.body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _pwdTextController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Compute PBKDF2',
              onPressed: () => bloc(context).pbkdf2(_pwdTextController.text),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Session',
              style: AppTypography.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Retrieve session key',
              onPressed: () => bloc(context).getSessionKey(),
            ),
          ),
        ],
      );
}
