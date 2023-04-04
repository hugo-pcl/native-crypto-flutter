// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_crypto_example/core/typography.dart';
import 'package:native_crypto_example/presentation/home/blocs/mode_switcher/mode_switcher_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class ButtonStateManagement
    extends CubitConsumerScreen<ModeSwitcherCubit, ModeSwitcherState> {
  const ButtonStateManagement({
    required this.label,
    this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final String label;

  @override
  Widget onBuild(BuildContext context, ModeSwitcherState state) {
    context.watch<ModeSwitcherCubit>();
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: state.currentMode.primaryColor,
      ),
      child: Text(
        label,
        style: AppTypography.body,
      ),
    );
  }
}
