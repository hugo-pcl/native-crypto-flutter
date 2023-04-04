// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/domain/entities/mode.dart';
import 'package:native_crypto_example/presentation/home/blocs/mode_switcher/mode_switcher_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class AppBarStateManagement
    extends CubitConsumerScreen<ModeSwitcherCubit, ModeSwitcherState> {
  const AppBarStateManagement({super.key});

  @override
  Widget onBuild(BuildContext context, ModeSwitcherState state) => AppBar(
        centerTitle: true,
        title: Text(
          state.currentMode == const NativeCryptoMode()
              ? 'NativeCrypto'
              : 'PointyCastle',
        ),
        backgroundColor: state.currentMode.primaryColor,
        // TODO(hpcl): enable mode switcher
        // actions: [
        //   Switch(
        //     value: state.currentMode == const NativeCryptoMode(),
        //     onChanged: (_) => bloc(context).switchMode(),
        //   )
        // ],
      );
}
