package fr.pointcheval.native_crypto_android

import androidx.annotation.NonNull
import fr.pointcheval.native_crypto_android.kdf.Pbkdf2
import fr.pointcheval.native_crypto_android.keys.SecretKey
import fr.pointcheval.native_crypto_android.utils.CipherAlgorithm
import fr.pointcheval.native_crypto_android.utils.Constants
import fr.pointcheval.native_crypto_android.utils.HashAlgorithm
import fr.pointcheval.native_crypto_android.utils.Task
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

/** NativeCryptoAndroidPlugin */
class NativeCryptoAndroidPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private val name = "plugins.hugop.cl/native_crypto"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, name)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        lateinit var methodCallTask: Task<*>

        when (call.method) {
            "digest" -> methodCallTask = handleDigest(call.arguments())
            "generateSecretKey" -> methodCallTask = handleGenerateSecretKey(call.arguments())
            "generateKeyPair" -> result.notImplemented()
            "pbkdf2" -> methodCallTask = handlePbkdf2(call.arguments())
            "encrypt" -> methodCallTask = handleEncrypt(call.arguments())
            "decrypt" -> methodCallTask = handleDecrypt(call.arguments())
            "generateSharedSecretKey" -> result.notImplemented()
            else -> result.notImplemented()
        }

        methodCallTask.call()

        methodCallTask.finalize { task ->
            if (task.isSuccessful()) {
                result.success(task.getResult())
            } else {
                val exception: Exception = task.getException()
                val message = exception.message
                result.error("native_crypto", message, null)
            }
        }
    }

    private fun handleDigest(arguments: Map<String, Any>?): Task<ByteArray> {
        return Task {
            val data: ByteArray =
                Objects.requireNonNull(arguments?.get(Constants.DATA)) as ByteArray
            val algorithm: String =
                Objects.requireNonNull(arguments?.get(Constants.ALGORITHM)) as String
            HashAlgorithm.digest(data, algorithm)
        }
    }

    private fun handleGenerateSecretKey(arguments: Map<String, Any>?): Task<ByteArray> {
        return Task {
            val bitsCount: Int = Objects.requireNonNull(arguments?.get(Constants.BITS_COUNT)) as Int
            SecretKey.fromSecureRandom(bitsCount).bytes
        }
    }

    private fun handlePbkdf2(arguments: Map<String, Any>?): Task<ByteArray> {
        return Task {
            val password: String =
                Objects.requireNonNull(arguments?.get(Constants.PASSWORD)) as String
            val salt: String = Objects.requireNonNull(arguments?.get(Constants.SALT)) as String
            val keyBytesCount: Int =
                Objects.requireNonNull(arguments?.get(Constants.KEY_BYTES_COUNT)) as Int
            val iterations: Int =
                Objects.requireNonNull(arguments?.get(Constants.ITERATIONS)) as Int
            val algorithm: String =
                Objects.requireNonNull(arguments?.get(Constants.ALGORITHM)) as String

            val pbkdf2: Pbkdf2 = Pbkdf2(keyBytesCount, iterations, HashAlgorithm.valueOf(algorithm))
            pbkdf2.init(password, salt)

            pbkdf2.derive().bytes
        }
    }

    private fun handleEncrypt(arguments: Map<String, Any>?): Task<ByteArray> {
        return Task {
            val data: ByteArray =
                Objects.requireNonNull(arguments?.get(Constants.DATA)) as ByteArray
            val key: ByteArray = Objects.requireNonNull(arguments?.get(Constants.KEY)) as ByteArray
            val algorithm: String =
                Objects.requireNonNull(arguments?.get(Constants.ALGORITHM)) as String

            val cipherAlgorithm: CipherAlgorithm = CipherAlgorithm.valueOf(algorithm)
            val cipher = cipherAlgorithm.getCipher()

            cipher.encrypt(data, key)
        }
    }

    private fun handleDecrypt(arguments: Map<String, Any>?): Task<ByteArray> {
        return Task {
            val data: ByteArray =
                Objects.requireNonNull(arguments?.get(Constants.DATA)) as ByteArray
            val key: ByteArray = Objects.requireNonNull(arguments?.get(Constants.KEY)) as ByteArray
            val algorithm: String =
                Objects.requireNonNull(arguments?.get(Constants.ALGORITHM)) as String

            val cipherAlgorithm: CipherAlgorithm = CipherAlgorithm.valueOf(algorithm)
            val cipher = cipherAlgorithm.getCipher()

            cipher.decrypt(data, key)
        }
    }
}
