// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/presentation/cipher/state_management/aes_state_management.dart';
import 'package:native_crypto_example/presentation/hash/state_management/hash_state_management.dart';
import 'package:native_crypto_example/presentation/home/blocs/navigation_bar/navigation_bar_cubit.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/app_bar_state_management.dart';
import 'package:native_crypto_example/presentation/home/state_management/widgets/bottom_navigation_bar_state_management.dart';
import 'package:native_crypto_example/presentation/home/widgets/blank.dart';
import 'package:native_crypto_example/presentation/kdf/state_management/key_derivation_state_management.dart';
import 'package:native_crypto_example/presentation/test_vectors/state_management/test_vectors_state_management.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class HomeStateManagement
    extends CubitScreen<NavigationBarCubit, NavigationBarState> {
  HomeStateManagement({super.key});

  final List<Widget> _children = [
    KeyDerivationStateManagement(),
    HashStateManagement(),
    AESStateManagement(),
    TestVectorsStateManagement(),
    const Blank()
  ];

  @override
  NavigationBarCubit create(BuildContext context) => NavigationBarCubit();

  @override
  Widget onBuild(BuildContext context, NavigationBarState state) => Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: AppBarStateManagement(),
        ),
        body: _children[state.index],
        bottomNavigationBar: BottomNavigationBarStateManagement(
          onTap: (page) => bloc(context).changePage(page), // new
          currentIndex: state.index, // new
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key),
              label: 'Key',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag),
              label: 'Hash',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Encryption',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rule_rounded),
              label: 'Tests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Benchmark',
            ),
          ],
        ),
      );
}
