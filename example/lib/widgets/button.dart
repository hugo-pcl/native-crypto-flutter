// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key key, this.onPressed, this.label}) : super(key: key);

  final void Function() onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: onPressed,
        color: Colors.blue,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
