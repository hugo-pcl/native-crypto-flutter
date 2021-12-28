package fr.pointcheval.native_crypto_android

import androidx.annotation.NonNull
import fr.pointcheval.native_crypto_android.ciphers.AESCipher

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NativeCryptoAndroidPlugin */
class NativeCryptoAndroidPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.hugop.cl/native_crypto")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "digest" -> {
        val data : ByteArray? = call.argument<ByteArray>("data")
        val algorithm : String? = call.argument<String>("algorithm")
        // TODO(hpcl): check if algorithm is null
        // TODO(hpcl): check if digest is null
        result.success(Hash.digest(data, algorithm!!))
      }
      "generateSecretKey" -> {
        val bitsCount : Int? = call.argument<Int>("bitsCount")
        // TODO(hpcl): check null
        result.success(Key.fromSecureRandom(bitsCount!!))
      }
      "generateKeyPair" -> {
        result.notImplemented()
      }
      "pbkdf2" -> {
        val password : String? = call.argument<String>("password")
        val salt : String? = call.argument<String>("salt")
        val keyBytesCount : Int? = call.argument<Int>("keyBytesCount")
        val iterations : Int? = call.argument<Int>("iterations")
        val algorithm : String? = call.argument<String>("algorithm")
        // TODO(hpcl): check null
        result.success(Key.fromPBKDF2(password!!, salt!!, keyBytesCount!!, iterations!!, algorithm!!))
      }
      "encrypt" -> {
        val data : ByteArray? = call.argument<ByteArray>("data")
        val key : ByteArray? = call.argument<ByteArray>("key")
        val algorithm : String? = call.argument<String>("algorithm")
        // TODO(hpcl): check null
        // TODO(hcpl): check algorithm
        result.success(AESCipher().encrypt(data!!, key!!))
      }
      "decrypt" ->  {
        val data : ByteArray? = call.argument<ByteArray>("data")
        val key : ByteArray? = call.argument<ByteArray>("key")
        val algorithm : String? = call.argument<String>("algorithm")
        // TODO(hpcl): check null
        // TODO(hcpl): check algorithm
        result.success(AESCipher().decrypt(data!!, key!!))
      }
      "generateSharedSecretKey" -> {
        result.notImplemented()
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
