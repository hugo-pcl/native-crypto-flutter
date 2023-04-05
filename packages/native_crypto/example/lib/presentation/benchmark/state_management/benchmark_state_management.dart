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
import 'package:native_crypto_example/presentation/benchmark/blocs/benchmark_cubit.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/button_state_management.dart';
import 'package:native_crypto_example/presentation/output/widgets/logs.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class BenchmarkStateManagement
    extends CubitScreen<BenchmarkCubit, BenchmarkState> {
  const BenchmarkStateManagement({super.key});

  @override
  BenchmarkCubit create(BuildContext context) => BenchmarkCubit(
        sessionRepository: repo<SessionRepository>(context),
        loggerRepository: repo<LoggerRepository>(context),
        cryptoRepository: repo<CryptoRepository>(context),
      );

  @override
  Widget onBuild(BuildContext context, BenchmarkState state) => ListView(
        children: [
          const Logs(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Benchmark',
              style: AppTypography.title,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '''In computer science, a benchmark is a standardized way to measure the performance of a software program or hardware device. A benchmark is typically a set of tests or tasks designed to measure how quickly a program can complete a given set of operations or how efficiently a hardware device can perform a specific task.''',
              style: AppTypography.body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ButtonStateManagement(
              label: 'Launch',
              onPressed: () => bloc(context).launchBenchmark(),
            ),
          ),
        ],
      );
}
