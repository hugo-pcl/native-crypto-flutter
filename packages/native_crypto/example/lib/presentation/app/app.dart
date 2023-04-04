// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto_example/core/get_it.dart';
import 'package:native_crypto_example/data/data_sources/native_crypto_data_source_impl.dart';
import 'package:native_crypto_example/data/repositories/crypto_repository_impl.dart';
import 'package:native_crypto_example/data/repositories/logger_repository_impl.dart';
import 'package:native_crypto_example/data/repositories/session_repository_impl.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/logger_repository.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';
import 'package:native_crypto_example/presentation/home/blocs/mode_switcher/mode_switcher_cubit.dart';
import 'package:native_crypto_example/presentation/home/state_management/home_state_management.dart';
import 'package:native_crypto_example/presentation/output/blocs/output/output_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class App extends StatelessWidget {
  App({super.key});

  final LoggerRepository _loggerRepository =
      LoggerRepositoryImpl(loggerDataSource: getIt());

  final SessionRepository _sessionRepository =
      SessionRepositoryImpl(sessionDataSource: getIt());

  @override
  Widget build(BuildContext context) => MultiProvider(
        repositoryProviders: [
          RepositoryProvider<LoggerRepository>.value(value: _loggerRepository),
          RepositoryProvider<SessionRepository>.value(
            value: _sessionRepository,
          ),
          RepositoryProvider<CryptoRepository>(
            create: (_) => CryptoRepositoryImpl(
              cryptoDataSource: getIt<NativeCryptoDataSourceImpl>(),
            ),
          ),
        ],
        blocProviders: [
          BlocProvider<OutputCubit>(
            create: (_) => OutputCubit(_loggerRepository),
          ),
          BlocProvider<ModeSwitcherCubit>(
            create: (_) => ModeSwitcherCubit(_sessionRepository),
          )
        ],
        child: MaterialApp(
          title: 'NativeCrypto',
          debugShowCheckedModeBanner: false,
          home: HomeStateManagement(),
        ),
      );
}
