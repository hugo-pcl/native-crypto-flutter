// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto/native_crypto.dart';
import 'package:native_crypto_example/core/typography.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:native_crypto_example/presentation/hash/blocs/hash/hash_cubit.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/button_state_management.dart';
import 'package:native_crypto_example/presentation/output/widgets/logs.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class HashStateManagement extends CubitScreen<HashCubit, HashState> {
  HashStateManagement({super.key});

  final TextEditingController _hashTextController = TextEditingController()
    ..text = 'abc';

  @override
  HashCubit create(BuildContext context) => HashCubit(
        loggerRepository: repo<LoggerRepository>(context),
        cryptoRepository: repo<CryptoRepository>(context),
      );

  @override
  Widget onBuild(BuildContext context, HashState state) => ListView(
        children: [
          const Logs(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Hash',
              style: AppTypography.title,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '''SHA-256, SHA-384, and SHA-512 are cryptographic hash functions. They are used to create a fixed-size output (known as a hash or digest) from an input of any size. The output of a hash function is deterministic, which means that the same input will always produce the same output.''',
              style: AppTypography.body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _hashTextController,
              decoration: const InputDecoration(
                hintText: 'Message',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'SHA256',
              onPressed: () => bloc(context).hash(
                Sha256(),
                _hashTextController.text,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'SHA384',
              onPressed: () => bloc(context).hash(
                Sha384(),
                _hashTextController.text,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'SHA512',
              onPressed: () => bloc(context).hash(
                Sha512(),
                _hashTextController.text,
              ),
            ),
          ),
        ],
      );
}
