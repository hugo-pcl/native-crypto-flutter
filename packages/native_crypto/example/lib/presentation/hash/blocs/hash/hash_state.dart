// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'hash_cubit.dart';

@immutable
class HashState {
  const HashState.initial()
      : state = State.initial,
        result = null,
        error = null;

  const HashState.loading()
      : state = State.loading,
        result = null,
        error = null;

  const HashState.failure(this.error)
      : state = State.failure,
        result = null;

  const HashState.success(this.result)
      : state = State.success,
        error = null;

  final State state;
  final Uint8List? result;
  final String? error;
}
