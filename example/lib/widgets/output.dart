// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'dart:developer';

import 'package:flutter/material.dart';

class Output extends StatelessWidget {
  const Output(
      {Key key,
      this.textEditingController,
      this.large: false,
      this.editable: false})
      : super(key: key);

  final TextEditingController textEditingController;
  final bool large;
  final bool editable;

  void print(String message) {
    log(message, name: "NativeCrypto Example");
    textEditingController.text = message;
  }

  void append(String message) {
    log(message, name: "NativeCrypto Example");
    textEditingController.text += message;
  }

  void appendln(String message) {
    log(message, name: "NativeCrypto Example");
    textEditingController.text += message + "\n";
  }

  void clear() {
    textEditingController.clear();
  }

  String read() {
    return textEditingController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        enableInteractiveSelection: true,
        readOnly: editable ? false : true,
        minLines: large ? 3 : 1,
        maxLines: large ? 500 : 5,
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: textEditingController,
      ),
    );
  }
}
