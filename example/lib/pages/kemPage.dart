// Copyright (c) 2020
// Author: Hugo Pointcheval
import 'package:flutter/material.dart';
import 'package:native_crypto/native_crypto.dart';

class KemPage extends StatefulWidget {
  KemPage({key}) : super(key: key);

  @override
  _KemPageState createState() => _KemPageState();
}

class _KemPageState extends State<KemPage> {
  void test() async {
    KeySpec specs = RSAKeySpec(2048);
    KeyPair kp = await KeyPair.generate(specs);
    print(kp.isComplete);
    print(kp.privateKey);
    print(kp.privateKey.encoded);
  }

  @override
  void initState() {
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Not implemented."),
      ),
    );
  }
}
