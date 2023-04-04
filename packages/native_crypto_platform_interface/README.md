# NativeCrypto - Platform Interface

A common platform interface for the [`native_crypto`][1] plugin.

This interface allows platform-specific implementations of the `native_crypto` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

## Usage

To implement a new platform-specific implementation of `native_crypto`, extend [`NativeCryptoPlatform`][2] with an implementation that performs the platform-specific behavior, and when you register your plugin, set the default `NativeCryptoPlatform` by calling `NativeCryptoPlatform.instance = MyNativeCryptoPlatform()`.

## Pigeon

This package uses [Pigeon](https://pub.dev/packages/pigeon) to generate the platform interface code.

Run generator with `flutter pub run pigeon --input pigeons/messages.dart`.

> Note: Make sure the `lib/src/gen` folder exists before running the generator.

[1]: ../native_crypto
[2]: lib/native_crypto_platform_interface.dart
