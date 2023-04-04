package fr.pointcheval.native_crypto_android

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** NativeCryptoAndroidPlugin */
class NativeCryptoAndroidPlugin : FlutterPlugin {
    private var nativeCrypto: NativeCrypto? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext
        nativeCrypto = NativeCrypto(context)
        NativeCryptoAPI.setUp(flutterPluginBinding.binaryMessenger, nativeCrypto)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        NativeCryptoAPI.setUp(binding.binaryMessenger, null)
        nativeCrypto = null
    }
}
