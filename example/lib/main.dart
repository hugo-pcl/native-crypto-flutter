// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'package:flutter/material.dart';
import 'package:native_crypto_example/pages/kemPage.dart';

import 'pages/benchmarkPage.dart';
import 'pages/cipherPage.dart';
import 'pages/hashKeyDerivationPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HashKeyDerivationPage(),
    CipherPage(),
    KemPage(),
    BenchmarkPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key),
              label: 'Key',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Encryption',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.connect_without_contact),
              label: 'KEM',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Benchmark',
            ),
          ],
        ),
      ),
    );
  }
}
