// Copyright 2019-2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'output_cubit.dart';

@immutable
class OutputState {
  const OutputState({
    required this.entries,
  });

  const OutputState.empty() : entries = const {};

  final Map<DateTime, LogMessage> entries;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer();
    entries.forEach((key, value) {
      buffer
        ..write(value.prefix)
        ..write(' at ')
        ..write(key.toIso8601String())
        ..write(':\t')
        ..writeln(value.message);
    });
    return buffer.toString();
  }
}
