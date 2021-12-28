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
    channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "plugins.hugop.cl/native_crypto")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "digest" -> {
        if (!call.hasArgument("data")) result.error("DATA_NULL", null, null);
        if (!call.hasArgument("algorithm")) result.error("ALGORITHM_NULL", null, null);

        val data : ByteArray = call.argument<ByteArray>("data")!!
        val algorithm : String = call.argument<String>("algorithm")!!

        result.success(Hash.digest(data, algorithm))
      }
      "generateSecretKey" -> {
        if (!call.hasArgument("bitsCount")) result.error("SIZE_NULL", null, null);

        val bitsCount : Int = call.argument<Int>("bitsCount")!!

        result.success(Key.fromSecureRandom(bitsCount))
      }
      "generateKeyPair" -> {
        result.notImplemented()
      }
      "pbkdf2" -> {
        if (!call.hasArgument("password")) result.error("PASSWORD_NULL", null, null);
        if (!call.hasArgument("salt")) result.error("SALT_NULL", null, null);
        if (!call.hasArgument("keyBytesCount")) result.error("SIZE_NULL", null, null);
        if (!call.hasArgument("iterations")) result.error("ITERATIONS_NULL", null, null);
        if (!call.hasArgument("algorithm")) result.error("ALGORITHM_NULL", null, null);

        val password : String = call.argument<String>("password")!!
        val salt : String = call.argument<String>("salt")!!
        val keyBytesCount : Int = call.argument<Int>("keyBytesCount")!!
        val iterations : Int = call.argument<Int>("iterations")!!
        val algorithm : String = call.argument<String>("algorithm")!!

        result.success(Key.fromPBKDF2(password, salt, keyBytesCount, iterations, algorithm))
      }
      "encrypt" -> {
        if (!call.hasArgument("data")) result.error("DATA_NULL", null, null);
        if (!call.hasArgument("key")) result.error("KEY_NULL", null, null);
        if (!call.hasArgument("algorithm")) result.error("ALGORITHM_NULL", null, null);

        val data : ByteArray = call.argument<ByteArray>("data")!!
        val key : ByteArray = call.argument<ByteArray>("key")!!
        val algorithm : String = call.argument<String>("algorithm")!!

        if (algorithm == "aes") {
          result.success(AESCipher().encrypt(data, key))
        }
      }
      "decrypt" ->  {
        if (!call.hasArgument("data")) result.error("DATA_NULL", null, null);
        if (!call.hasArgument("key")) result.error("KEY_NULL", null, null);
        if (!call.hasArgument("algorithm")) result.error("ALGORITHM_NULL", null, null);

        val data : ByteArray = call.argument<ByteArray>("data")!!
        val key : ByteArray = call.argument<ByteArray>("key")!!
        val algorithm : String = call.argument<String>("algorithm")!!

        if (algorithm == "aes") {
          result.success(AESCipher().decrypt(data, key))
        }
      }
      "generateSharedSecretKey" -> {
        if (!call.hasArgument("salt")) result.error("SALT_NULL", null, null);
        if (!call.hasArgument("keyBytesCount")) result.error("SIZE_NULL", null, null);
        if (!call.hasArgument("ephemeralPrivateKey")) result.error("PRIVATE_KEY_NULL", null, null);
        if (!call.hasArgument("otherPublicKey")) result.error("PUBLIC_KEY_NULL", null, null);
        if (!call.hasArgument("hkdfAlgorithm")) result.error("ALGORITHM_NULL", null, null);

        val salt : ByteArray = call.argument<ByteArray>("salt")!!
        val keyBytesCount : Int = call.argument<Int>("keyBytesCount")!!
        val ephemeralPrivateKey : ByteArray = call.argument<ByteArray>("ephemeralPrivateKey")!!
        val otherPublicKey : ByteArray = call.argument<ByteArray>("otherPublicKey")!!
        val hkdfAlgorithm : String = call.argument<String>("hkdfAlgorithm")!!

        result.notImplemented()
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
