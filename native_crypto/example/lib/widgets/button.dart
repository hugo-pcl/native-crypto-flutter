// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: button.dart
// Created Date: 28/12/2021 13:31:17
// Last Modified: 28/12/2021 13:31:34
// -----
// Copyright (c) 2021

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() onPressed;
  final String label;

  const Button(this.onPressed, this.label, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
