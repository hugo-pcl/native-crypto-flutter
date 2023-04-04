// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'mode_switcher_cubit.dart';

@immutable
class ModeSwitcherState {
  const ModeSwitcherState(this.currentMode);

  final Mode currentMode;

  @override
  bool operator ==(covariant ModeSwitcherState other) {
    if (identical(this, other)) {
      return true;
    }

    return other.currentMode == currentMode;
  }

  @override
  int get hashCode => currentMode.hashCode;
}
