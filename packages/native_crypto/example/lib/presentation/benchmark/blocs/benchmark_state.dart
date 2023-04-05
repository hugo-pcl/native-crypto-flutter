// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'benchmark_cubit.dart';

@immutable
class BenchmarkState {
  const BenchmarkState.initial()
      : state = State.initial,
        error = null;

  const BenchmarkState.loading()
      : state = State.loading,
        error = null;

  const BenchmarkState.failure(this.error) : state = State.failure;

  const BenchmarkState.success()
      : state = State.success,
        error = null;

  final State state;
  final String? error;
}
