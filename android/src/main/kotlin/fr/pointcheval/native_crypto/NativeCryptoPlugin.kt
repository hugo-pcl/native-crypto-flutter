/*
 * Copyright (c) 2020
 * Author: Hugo Pointcheval
 */
package fr.pointcheval.native_crypto
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.*
import kotlin.coroutines.*

/** NativeCryptoPlugin */
class NativeCryptoPlugin(contextm: Context? = null) : FlutterPlugin, MethodCallHandler {
    public var context: Context?;
    init {
        context = contextm;
    }
    public val mainScope = CoroutineScope(Dispatchers.Main);
    //public lateinit var context: Context;
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        //context = flutterPluginBinding.applicationContext;
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "native.crypto")
        channel.setMethodCallHandler(NativeCryptoPlugin(flutterPluginBinding.applicationContext));
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native.crypto")
            channel.setMethodCallHandler(NativeCryptoPlugin(registrar.context()))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "digest" -> {
                val message = call.argument<ByteArray>("message")
                val algorithm = call.argument<String>("algorithm")

                try {
                    val d = Hash().digest(message, algorithm!!)
                    if (d.isNotEmpty()) {
                        result.success(d)
                    } else {
                        result.error("DIGESTERROR", "DIGEST IS NULL.", null)
                    }
                } catch (e : Exception) {
                    result.error("DIGESTEXCEPTION", e.message, null)
                }
            }
            "pbkdf2" -> {
                val password = call.argument<String>("password")
                val salt = call.argument<String>("salt")
                val keyLength = call.argument<Int>("keyLength")
                val iteration = call.argument<Int>("iteration")
                val algorithm = call.argument<String>("algorithm")

                try {
                    val key = KeyDerivation().pbkdf2(password!!, salt!!, keyLength!!, iteration!!, algorithm!!)
                    if (key.isNotEmpty()) {
                        result.success(key)
                    } else {
                        result.error("PBKDF2ERROR", "PBKDF2 KEY IS NULL.", null)
                    }
                } catch (e : Exception) {
                    result.error("PBKDF2EXCEPTION", e.message, null)
                }
            }
            "keygen" -> {
                val size = call.argument<Int>("size") // 128, 192, 256
                try {
                    val key = KeyGeneration().keygen(size!!)

                    if (key.isNotEmpty()) {
                        result.success(key)
                    } else {
                        result.error("KEYGENERROR", "GENERATED KEY IS NULL.", null)
                    }
                } catch (e : Exception) {
                    result.error("KEYGENEXCEPTION", e.message, null)
                }
            }
            "rsaKeypairGen" -> {
                val size = call.argument<Int>("size")
                try {
                    val keypair = KeyGeneration().rsaKeypairGen(size!!)

                    if (keypair.isNotEmpty()) {
                        result.success(keypair)
                    } else {
                        result.error("KEYPAIRGENERROR", "GENERATED KEYPAIR IS EMPTY.", null)
                    }
                } catch (e : Exception) {
                    result.error("KEYPAIRGENEXCEPTION", e.message, null)
                }
            }
            "encrypt" -> {
                val data = call.argument<ByteArray>("data")
                val key = call.argument<ByteArray>("key")
                val algorithm = call.argument<String>("algorithm")
                val mode = call.argument<String>("mode")
                val padding = call.argument<String>("padding")

                try {
                    val payload = Cipher(context!!).encrypt(data!!, key!!, algorithm!!, mode!!, padding!!)

                    if (payload.isNotEmpty()) {
                        result.success(payload)
                    } else {
                        result.error("ENCRYPTIONERROR", "ENCRYPTED PAYLOAD IS EMPTY.", null)
                    }
                } catch (e: Exception) {
                    result.error("ENCRYPTIONEXCEPTION", e.message, null)
                }

            }
            "decrypt" -> {
                val payload = call.argument<Collection<ByteArray>>("payload") // Collection<ByteArray>

                val key = call.argument<ByteArray>("key")
                val algorithm = call.argument<String>("algorithm")
                val mode = call.argument<String>("mode")
                val padding = call.argument<String>("padding")

                var decryptedPayload : ByteArray? = null

                try {
                    decryptedPayload = Cipher(context!!).decrypt(payload!!, key!!, algorithm!!, mode!!, padding!!)
                    if (decryptedPayload != null && decryptedPayload.isNotEmpty()) {
                        result.success(decryptedPayload)
                    } else {
                        result.error("DECRYPTIONERROR", "DECRYPTED PAYLOAD IS NULL. MAYBE VERIFICATION MAC IS INVALID.", null)
                    }
                } catch (e : Exception) {
                    result.error("DECRYPTIONEXCEPTION", e.message, null);
                }
            }
            "encryptFile" -> {
                mainScope.launch {
                    val outputFilePath = call.argument<String>("outputFilePath");
                    val inputFilePath = call.argument<String>("inputFilePath");
                    val key = call.argument<ByteArray>("key");
                    val mode = call.argument<String>("mode");
                    val padding = call.argument<String>("padding");
                    val algorithm = call.argument<String>("algorithm");
                    try {
                        val encryptionIv: ByteArray? = withContext(Dispatchers.Default) {
                            Cipher(context!!).encryptFile(inputFilePath!!,outputFilePath!!,algorithm!!,key!!,mode!!,padding!!);
                        }
                        if (encryptionIv != null){
                            result.success(encryptionIv)
                        } else {
                            result.error("FILEDECRYPTIONERROR","the decryption process failed",null);
                        }
                    } catch (e: Exception) {
                        result.error("FILEENCRYPTIONEXCEPTION",e.message,null);
                    }
                }
                
            }
            "decryptFile" -> {
                mainScope.launch {
                    val outputFilePath = call.argument<String>("outputFilePath");
                    val inputFilePath = call.argument<String>("inputFilePath");
                    val key = call.argument<ByteArray>("key");
                    val mode = call.argument<String>("mode");
                    val padding = call.argument<String>("padding");
                    val algorithm = call.argument<String>("algorithm");
                    val iv = call.argument<ByteArray>("iv");
                    try {
                        val decryption: Boolean = withContext(Dispatchers.Default) {
                            Cipher(context!!).decryptFile(inputFilePath!!,outputFilePath!!,algorithm!!,key!!,iv!!,mode!!,padding!!);
                        }
                        if (decryption == true) {
                            result.success(decryption);
                        } else {
                            result.error("FILEDECRYPTIONERROR","failed to decrypt file",null);
                        }
                    } catch (e: Exception) {
                        result.error("FILEDECRYPTIONEXCEPTION",e.message,null);
                    }
                }
                

            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
