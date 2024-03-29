// Copyright 2019-2023 Hugo Pointcheval
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
// --
// Autogenerated from Pigeon (v9.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package fr.pointcheval.native_crypto_android

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class HashAlgorithm(val raw: Int) {
  SHA256(0),
  SHA384(1),
  SHA512(2);

  companion object {
    fun ofRaw(raw: Int): HashAlgorithm? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class CipherAlgorithm(val raw: Int) {
  AES(0);

  companion object {
    fun ofRaw(raw: Int): CipherAlgorithm? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}
/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface NativeCryptoAPI {
  fun hash(data: ByteArray, algorithm: HashAlgorithm): ByteArray?
  fun hmac(data: ByteArray, key: ByteArray, algorithm: HashAlgorithm): ByteArray?
  fun generateSecureRandom(length: Long): ByteArray?
  fun pbkdf2(password: ByteArray, salt: ByteArray, length: Long, iterations: Long, algorithm: HashAlgorithm): ByteArray?
  fun encrypt(plainText: ByteArray, key: ByteArray, algorithm: CipherAlgorithm): ByteArray?
  fun encryptWithIV(plainText: ByteArray, iv: ByteArray, key: ByteArray, algorithm: CipherAlgorithm): ByteArray?
  fun decrypt(cipherText: ByteArray, key: ByteArray, algorithm: CipherAlgorithm): ByteArray?
  fun encryptFile(plainTextPath: String, cipherTextPath: String, key: ByteArray, algorithm: CipherAlgorithm): Boolean?
  fun encryptFileWithIV(plainTextPath: String, cipherTextPath: String, iv: ByteArray, key: ByteArray, algorithm: CipherAlgorithm): Boolean?
  fun decryptFile(cipherTextPath: String, plainTextPath: String, key: ByteArray, algorithm: CipherAlgorithm): Boolean?

  companion object {
    /** The codec used by NativeCryptoAPI. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
    /** Sets up an instance of `NativeCryptoAPI` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: NativeCryptoAPI?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.hash", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val dataArg = args[0] as ByteArray
            val algorithmArg = HashAlgorithm.ofRaw(args[1] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.hash(dataArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.hmac", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val dataArg = args[0] as ByteArray
            val keyArg = args[1] as ByteArray
            val algorithmArg = HashAlgorithm.ofRaw(args[2] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.hmac(dataArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.generateSecureRandom", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val lengthArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.generateSecureRandom(lengthArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.pbkdf2", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val passwordArg = args[0] as ByteArray
            val saltArg = args[1] as ByteArray
            val lengthArg = args[2].let { if (it is Int) it.toLong() else it as Long }
            val iterationsArg = args[3].let { if (it is Int) it.toLong() else it as Long }
            val algorithmArg = HashAlgorithm.ofRaw(args[4] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.pbkdf2(passwordArg, saltArg, lengthArg, iterationsArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.encrypt", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val plainTextArg = args[0] as ByteArray
            val keyArg = args[1] as ByteArray
            val algorithmArg = CipherAlgorithm.ofRaw(args[2] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.encrypt(plainTextArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.encryptWithIV", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val plainTextArg = args[0] as ByteArray
            val ivArg = args[1] as ByteArray
            val keyArg = args[2] as ByteArray
            val algorithmArg = CipherAlgorithm.ofRaw(args[3] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.encryptWithIV(plainTextArg, ivArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.decrypt", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val cipherTextArg = args[0] as ByteArray
            val keyArg = args[1] as ByteArray
            val algorithmArg = CipherAlgorithm.ofRaw(args[2] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.decrypt(cipherTextArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.encryptFile", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val plainTextPathArg = args[0] as String
            val cipherTextPathArg = args[1] as String
            val keyArg = args[2] as ByteArray
            val algorithmArg = CipherAlgorithm.ofRaw(args[3] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.encryptFile(plainTextPathArg, cipherTextPathArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.encryptFileWithIV", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val plainTextPathArg = args[0] as String
            val cipherTextPathArg = args[1] as String
            val ivArg = args[2] as ByteArray
            val keyArg = args[3] as ByteArray
            val algorithmArg = CipherAlgorithm.ofRaw(args[4] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.encryptFileWithIV(plainTextPathArg, cipherTextPathArg, ivArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCryptoAPI.decryptFile", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val cipherTextPathArg = args[0] as String
            val plainTextPathArg = args[1] as String
            val keyArg = args[2] as ByteArray
            val algorithmArg = CipherAlgorithm.ofRaw(args[3] as Int)!!
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.decryptFile(cipherTextPathArg, plainTextPathArg, keyArg, algorithmArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
