// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

extension ListIntExtension on List<int> {
  /// Converts a [List] of int to a [Uint8List].
  Uint8List toTypedList() => Uint8List.fromList(this);
}
