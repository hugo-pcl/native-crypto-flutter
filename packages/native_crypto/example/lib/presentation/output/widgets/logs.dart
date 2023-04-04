// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/core/typography.dart';
import 'package:native_crypto_example/presentation/output/state_management/output_state_management.dart';
import 'package:native_crypto_example/presentation/output/state_management/widgets/clear_button_state_management.dart';

class Logs extends StatelessWidget {
  const Logs({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Logs',
                  style: AppTypography.title,
                ),
                ClearButtonStateManagement(),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
            width: double.infinity,
            child: ColoredBox(color: Colors.black),
          ),
          OutputStateManagement(),
          const SizedBox(
            height: 2,
            width: double.infinity,
            child: ColoredBox(color: Colors.black),
          ),
        ],
      );
}
