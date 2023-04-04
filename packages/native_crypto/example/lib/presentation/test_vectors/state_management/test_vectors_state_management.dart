// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/core/typography.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/button_state_management.dart';
import 'package:native_crypto_example/presentation/output/widgets/logs.dart';
import 'package:native_crypto_example/presentation/test_vectors/blocs/test_vectors/test_vectors_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class TestVectorsStateManagement
    extends CubitScreen<TestVectorsCubit, TestVectorsState> {
  TestVectorsStateManagement({super.key});

  final TextEditingController _vectorNumberTextController =
      TextEditingController();

  @override
  TestVectorsCubit create(BuildContext context) => TestVectorsCubit(
        loggerRepository: repo<LoggerRepository>(context),
        cryptoRepository: repo<CryptoRepository>(context),
      );

  @override
  Widget onBuild(BuildContext context, TestVectorsState state) => ListView(
        children: [
          const Logs(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Test vectors',
              style: AppTypography.title,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '''In cryptography, a test vector is a set of input values that is used to test the correct implementation and operation of a cryptographic algorithm or system. Test vectors are usually provided by the creators of the algorithm, or by national standardization organizations, and can be used to verify that an implementation of the algorithm is correct and produces the expected output for a given set of inputs.''',
              style: AppTypography.body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'All Tests',
              onPressed: () => bloc(context).launchAllTests(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _vectorNumberTextController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Vector number',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Specific Test',
              onPressed: () =>
                  bloc(context).launchTest(_vectorNumberTextController.text),
            ),
          ),
        ],
      );
}
