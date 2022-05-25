// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: output.dart
// Created Date: 28/12/2021 13:31:39
// Last Modified: 25/05/2022 16:39:39
// -----
// Copyright (c) 2021

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Output extends StatelessWidget {
  late TextEditingController controller;
  final bool large;
  final bool editable;

  Output({
    Key? key,
    TextEditingController? controller,
    this.large = false,
    this.editable = false,
  }) : super(key: key) {
    this.controller = controller ?? TextEditingController();
  }

  void print(String message) {
    debugPrint(message);
    controller.text = message;
  }

  void append(String message) {
    debugPrint(message);
    controller.text += message;
  }

  void appendln(String message) {
    debugPrint(message);
    controller.text += message + "\n";
  }

  void clear() {
    controller.clear();
  }

  String read() {
    return controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enableInteractiveSelection: true,
      readOnly: editable ? false : true,
      minLines: large ? 3 : 1,
      maxLines: large ? 500 : 5,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      controller: controller,
    );
  }
}
