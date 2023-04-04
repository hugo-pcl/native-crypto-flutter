// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:native_crypto_example/presentation/output/blocs/output/output_cubit.dart';
import 'package:wyatt_bloc_helper/wyatt_bloc_helper.dart';

class OutputStateManagement
    extends CubitConsumerScreen<OutputCubit, OutputState> {
  OutputStateManagement({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget onBuild(BuildContext context, OutputState state) {
    // Auto scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });

    return SizedBox(
      height: 250,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: state.entries.length,
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            height: 1,
            child: ColoredBox(color: Colors.black),
          ),
        ),
        itemBuilder: (context, index) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state.entries.values.elementAt(index).prefix,
                  style: TextStyle(
                    color: state.entries.values.elementAt(index).color,
                  ),
                ),
                Text(
                  state.entries.keys.elementAt(index).toIso8601String(),
                  style: TextStyle(
                    color: state.entries.values.elementAt(index).color,
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                state.entries.values.elementAt(index).message,
                style: TextStyle(
                  color: state.entries.values.elementAt(index).color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
