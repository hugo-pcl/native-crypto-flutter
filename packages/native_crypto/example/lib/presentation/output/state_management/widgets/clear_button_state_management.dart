// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/button_state_management.dart';
import 'package:native_crypto_example/presentation/output/blocs/output/output_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class ClearButtonStateManagement
    extends CubitConsumerScreen<OutputCubit, OutputState> {
  const ClearButtonStateManagement({super.key});

  @override
  Widget onBuild(BuildContext context, OutputState state) =>
      ButtonStateManagement(
        label: 'Clear',
        onPressed: () => bloc(context).clear(),
      );
}
