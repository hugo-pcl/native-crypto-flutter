// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto_example/data/repositories/crypto_repository_switchable_impl.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:native_crypto_example/domain/repositories/crypto_repository.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';

part 'mode_switcher_state.dart';

class ModeSwitcherCubit extends Cubit<ModeSwitcherState> {
  ModeSwitcherCubit(
    this.sessionRepository,
    this.cryptoRepository,
  ) : super(const ModeSwitcherState(NativeCryptoMode()));

  SessionRepository sessionRepository;
  CryptoRepository cryptoRepository;

  FutureOr<void> switchMode() async {
    final currentMode = await sessionRepository.getCurrentMode();
    Mode? newMode;

    if (currentMode.isOk) {
      if (currentMode.ok == const NativeCryptoMode()) {
        newMode = const PointyCastleMode();
      } else {
        newMode = const NativeCryptoMode();
      }

      sessionRepository.setCurrentMode(newMode);
      if (cryptoRepository is CryptoRepositorySwitchableImpl) {
        (cryptoRepository as CryptoRepositorySwitchableImpl).mode = newMode;
      }
    } else {
      newMode = const NativeCryptoMode();
      sessionRepository.setCurrentMode(newMode);

      if (cryptoRepository is CryptoRepositorySwitchableImpl) {
        (cryptoRepository as CryptoRepositorySwitchableImpl).mode = newMode;
      }
    }

    emit(ModeSwitcherState(newMode));
  }
}
