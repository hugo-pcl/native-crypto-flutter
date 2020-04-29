/*
 * Copyright (c) 2020
 * Author: Hugo Pointcheval
 */
package fr.pointcheval.native_crypto

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.security.MessageDigest
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec


/** NativeCryptoPlugin */
public class NativeCryptoPlugin : FlutterPlugin, MethodCallHandler {
    // CRYPTO CONSTS
    private val HASH_FUNC = "SHA-256"
    private val SYM_CRYPTO_METHOD = "AES"
    private val SYM_CRYPTO_PADDING = "AES/CBC/PKCS5PADDING"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "native.crypto.helper")
        channel.setMethodCallHandler(NativeCryptoPlugin());
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native.crypto.helper")
            channel.setMethodCallHandler(NativeCryptoPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "pbkdf2") {

            val password = call.argument<String>("password")
            val salt = call.argument<String>("salt")
            val keyLength = call.argument<Int>("keyLength")
            val iteration = call.argument<Int>("iteration")
            val algorithm = call.argument<String>("algorithm")

            val key = pbkdf2(password!!, salt!!, keyLength!!, iteration!!, algorithm!!)

            if (key.isNotEmpty()) {
                result.success(key)
            } else {
                result.error("PBKDF2ERROR", "PBKDF2 KEY IS NULL.", null)
            }
        } else if (call.method == "symKeygen") {
            val keySize = call.argument<Int>("size") // 128, 192, 256

            val aesKey = symKeygen(keySize!!) // Collection<ByteArray>

            if (aesKey.isNotEmpty()) {
                result.success(aesKey)
            } else {
                result.error("SYMKEYGENERROR", "GENERATED KEY IS NULL.", null)
            }
        } else if (call.method == "symEncrypt") {
            val payload = call.argument<ByteArray>("payload") // ByteArray
            val aesKey = call.argument<ByteArray>("aesKey") // ByteArray

            val encryptedPayload = symEncrypt(payload!!, aesKey!!) // Collection<ByteArray>

            if (encryptedPayload.isNotEmpty()) {
                result.success(encryptedPayload)
            } else {
                result.error("ENCRYPTIONERROR", "ENCRYPTED PAYLOAD IS NULL.", null)
            }
        } else if (call.method == "symDecrypt") {
            val payload = call.argument<Collection<ByteArray>>("payload") // Collection<ByteArray>
            val aesKey = call.argument<ByteArray>("aesKey") // ByteArray
            var decryptedPayload : ByteArray? = null

            try {
                decryptedPayload = symDecrypt(payload!!, aesKey!!)
                if (decryptedPayload != null && decryptedPayload.isNotEmpty()) {
                    result.success(decryptedPayload)
                } else {
                    result.error("DECRYPTIONERROR", "DECRYPTED PAYLOAD IS NULL. MAYBE VERIFICATION MAC IS UNVALID.", null)
                }
            } catch (e : Exception) {
                result.error("DECRYPTIONERROR", "AN ERROR OCCURED WHILE DECRYPTING.", null)
            }
            
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    // CRYPTO NATIVE FUNCTIONS

    private fun digest(obj: ByteArray?): ByteArray {
        val md = MessageDigest.getInstance(HASH_FUNC)
        return md.digest(obj)
    }

    private fun pbkdf2(password : String, salt : String, keyLength : Int, iteration : Int, algorithm : String) : ByteArray {
        val chars: CharArray = password.toCharArray()

        val spec = PBEKeySpec(chars, salt.toByteArray(), iteration, keyLength * 8)
        val skf: SecretKeyFactory = if (algorithm == "sha1") {
            SecretKeyFactory.getInstance("PBKDF2withHmacSHA1")
        } else if (algorithm == "sha256") {
            SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        } else {
            SecretKeyFactory.getInstance("PBKDF2withHmacSHA512")
        }
        return skf.generateSecret(spec).encoded
    }

    private fun symKeygen(keySize : Int): ByteArray {

        val SYM_CRYPTO_BITS = keySize

        val secureRandom = SecureRandom()
        val keyGenerator = KeyGenerator.getInstance(SYM_CRYPTO_METHOD)
        keyGenerator?.init(SYM_CRYPTO_BITS, secureRandom)
        val skey = keyGenerator?.generateKey()

        return skey!!.encoded
    }

    private fun symEncrypt(payload: ByteArray, aesKey: ByteArray): Collection<ByteArray> {

        val mac = digest(aesKey + payload)
        val key: SecretKey = SecretKeySpec(aesKey, SYM_CRYPTO_METHOD)

        val cipher = Cipher.getInstance(SYM_CRYPTO_PADDING)
        cipher.init(Cipher.ENCRYPT_MODE, key)

        val encryptedBytes = cipher.doFinal(mac + payload)
        val iv = cipher.iv

        return listOf(encryptedBytes, iv);
    }

    private fun symDecrypt(payload: Collection<ByteArray>, aesKey: ByteArray): ByteArray? {

        val key: SecretKey = SecretKeySpec(aesKey, SYM_CRYPTO_METHOD)
        val cipher = Cipher.getInstance(SYM_CRYPTO_PADDING);
        val iv = payload.last();
        val ivSpec = IvParameterSpec(iv)
        cipher.init(Cipher.DECRYPT_MODE, key, ivSpec);

        val decryptedBytes = cipher.doFinal(payload.first());

        val mac = decryptedBytes.copyOfRange(0, 32)
        val decryptedContent = decryptedBytes.copyOfRange(32, decryptedBytes.size)
        val verificationMac = digest(aesKey + decryptedContent)

        if (mac.contentEquals(verificationMac)) return decryptedContent

        return null;
    }

}
