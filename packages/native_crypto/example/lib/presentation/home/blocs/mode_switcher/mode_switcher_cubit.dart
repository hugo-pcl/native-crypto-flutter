// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:native_crypto_example/domain/repositories/session_repository.dart';

part 'mode_switcher_state.dart';

class ModeSwitcherCubit extends Cubit<ModeSwitcherState> {
  ModeSwitcherCubit(
    this.sessionRepository,
  ) : super(const ModeSwitcherState(NativeCryptoMode()));
  SessionRepository sessionRepository;

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
    } else {
      newMode = const NativeCryptoMode();
      sessionRepository.setCurrentMode(newMode);
    }

    emit(ModeSwitcherState(newMode));
  }
}
