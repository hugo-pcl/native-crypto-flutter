// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'test_vectors_cubit.dart';

@immutable
class TestVectorsState {
  const TestVectorsState.initial()
      : state = State.initial,
        error = null;

  const TestVectorsState.loading()
      : state = State.loading,
        error = null;

  const TestVectorsState.failure(this.error) : state = State.failure;

  const TestVectorsState.success()
      : state = State.success,
        error = null;

  final State state;
  final String? error;
}
