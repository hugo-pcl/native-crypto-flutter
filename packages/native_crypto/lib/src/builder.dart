// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: builder.dart
// Created Date: 28/12/2021 12:02:34
// Last Modified: 28/12/2021 12:32:12
// -----
// Copyright (c) 2021

abstract class Builder<T> {
  Future<T> build();
}
