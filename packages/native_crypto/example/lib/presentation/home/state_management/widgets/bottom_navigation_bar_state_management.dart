// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/presentation/home/blocs/mode_switcher/mode_switcher_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class BottomNavigationBarStateManagement
    extends CubitConsumerScreen<ModeSwitcherCubit, ModeSwitcherState> {
  const BottomNavigationBarStateManagement({
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    super.key,
  });

  final void Function(int)? onTap;
  final int currentIndex;
  final List<BottomNavigationBarItem> items;

  @override
  Widget onBuild(BuildContext context, ModeSwitcherState state) =>
      BottomNavigationBar(
        selectedItemColor: state.currentMode.primaryColor,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: onTap,
        currentIndex: currentIndex,
        items: items,
        type: BottomNavigationBarType.shifting,
      );
}
