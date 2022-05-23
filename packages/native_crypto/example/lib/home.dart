// Author: Hugo Pointcheval
// Email: git@pcl.ovh
// -----
// File: home.dart
// Created Date: 28/12/2021 13:48:36
// Last Modified: 28/12/2021 15:18:03
// -----
// Copyright (c) 2021

import 'package:flutter/material.dart';
import 'package:native_crypto_example/pages/benchmark_page.dart';

import 'pages/cipher_page.dart';
import 'pages/kdf_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    KdfPage(),
    CipherPage(),
    BenchmarkPage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Native Crypto'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'Key',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Encryption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Benchmark',
          ),
        ],
      ),
    );
  }
}
