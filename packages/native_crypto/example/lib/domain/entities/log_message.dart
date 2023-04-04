// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

class LogMessage {
  const LogMessage(this.prefix, this.color, this.message);

  final String prefix;
  final Color color;
  final String message;
}

class LogInfo extends LogMessage {
  const LogInfo(String message) : super('info', Colors.black, message);
}

class LogWarning extends LogMessage {
  const LogWarning(String message) : super('warn', Colors.orange, message);
}

class LogError extends LogMessage {
  const LogError(String message) : super('fail', Colors.red, message);
}
