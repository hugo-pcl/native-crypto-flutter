// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: builder.dart
// Created Date: 28/12/2021 12:02:34
// Last Modified: 23/05/2022 22:38:44
// -----
// Copyright (c) 2021

// ignore_for_file: one_member_abstracts

abstract class Builder<T> {
  Future<T> build();
}
