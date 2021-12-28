import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_crypto_platform_interface/native_crypto_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NativeCryptoPlatform _nativeCryptoPlatform = NativeCryptoPlatform.instance;
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    Uint8List? sk = await _nativeCryptoPlatform.generateSecretKey(256);
    print(sk ?? 'null');

    Uint8List? ciphertext = await _nativeCryptoPlatform.encrypt(
        Uint8List.fromList("abc".codeUnits), sk!, "aes");
    print(ciphertext ?? 'null');

    Uint8List? plaintext =
        await _nativeCryptoPlatform.decrypt(ciphertext!, sk, "aes");
    print(plaintext ?? 'null');

    try {
      platformVersion = 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
