// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';

class Mode extends Entity {
  const Mode(
    this.primaryColor,
    this.secondaryColor,
  );

  final Color primaryColor;
  final Color secondaryColor;
}

class NativeCryptoMode extends Mode {
  const NativeCryptoMode()
      : super(
          Colors.blue,
          Colors.black,
        );
}

class PointyCastleMode extends Mode {
  const PointyCastleMode()
      : super(
          Colors.red,
          Colors.white,
        );
}
