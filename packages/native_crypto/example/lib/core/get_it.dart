// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:get_it/get_it.dart';
import 'package:native_crypto_example/data/data_sources/logger_data_source_impl.dart';
import 'package:native_crypto_example/data/data_sources/native_crypto_data_source_impl.dart';
import 'package:native_crypto_example/data/data_sources/pointy_castle_data_source_impl.dart';
import 'package:native_crypto_example/data/data_sources/session_data_source_impl.dart';
import 'package:native_crypto_example/domain/data_sources/logger_data_source.dart';
import 'package:native_crypto_example/domain/data_sources/session_data_source.dart';

final getIt = GetIt.I;

abstract class GetItInitializer {
  static Future<void> init() async {
    getIt
      ..registerLazySingleton<SessionDataSource>(
        SessionDataSourceImpl.new,
      )
      ..registerLazySingleton<LoggerDataSource>(
        LoggerDataSourceImpl.new,
      )
      ..registerLazySingleton<NativeCryptoDataSourceImpl>(
        NativeCryptoDataSourceImpl.new,
      )
      ..registerLazySingleton<PointyCastleDataSourceImpl>(
        PointyCastleDataSourceImpl.new,
      );

    await getIt.allReady();
  }
}
