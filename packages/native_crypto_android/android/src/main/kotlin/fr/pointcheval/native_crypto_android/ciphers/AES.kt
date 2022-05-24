package fr.pointcheval.native_crypto_android.ciphers

import fr.pointcheval.native_crypto_android.interfaces.Cipher
import fr.pointcheval.native_crypto_android.utils.CipherAlgorithm
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

class AES : Cipher {
    override val algorithm: CipherAlgorithm
        get() = CipherAlgorithm.aes

    var forEncryption: Boolean = true
    var cipherInstance: javax.crypto.Cipher? = null;
    var secretKey: SecretKeySpec? = null;

/*    override fun encrypt(data: ByteArray, key: ByteArray): ByteArray {
        val sk: SecretKey = SecretKeySpec(key, "AES")
        val cipher = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        // javax.crypto representation = [CIPHERTEXT(n-16) || TAG(16)]
        val bytes = cipher.doFinal(data)
        val iv = cipher.iv.copyOf()                                                 // 12 bytes nonce
        // native.crypto representation = [NONCE(12) || CIPHERTEXT(n-28) || TAG(16)]
        return iv.plus(bytes)
    }

    override fun decrypt(data: ByteArray, key: ByteArray): ByteArray {
        val sk: SecretKey = SecretKeySpec(key, "AES")
        // native.crypto representation = [NONCE(12) || CIPHERTEXT(n-16) || TAG(16)]
        val iv: ByteArray = data.take(12).toByteArray()
        // javax.crypto representation = [CIPHERTEXT(n-28) || TAG(16)]
        val payload: ByteArray = data.drop(12).toByteArray()
        val spec = GCMParameterSpec(16 * 8, iv)
        val cipher = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, sk, spec)
        return cipher.doFinal(payload)
    }*/

    override fun encrypt(data: ByteArray, key: ByteArray): ByteArray {
        val list : List<ByteArray> = encryptAsList(data, key)
        return list.first().plus(list.last())
    }

    override fun encryptAsList(data: ByteArray, key: ByteArray): List<ByteArray> {
        val sk = SecretKeySpec(key, "AES")
        if (cipherInstance == null || !forEncryption || secretKey != sk) {
            secretKey = sk
            forEncryption = true
            // native.crypto representation = [IV(16) || CIPHERTEXT(n-16)]
            // javax.crypto representation = [CIPHERTEXT(n-16)]
            cipherInstance = javax.crypto.Cipher.getInstance("AES/CBC/PKCS5Padding")
            cipherInstance!!.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        }
        // javax.crypto representation = [CIPHERTEXT(n-16)]
        val bytes: ByteArray = cipherInstance!!.doFinal(data)
        val iv: ByteArray = cipherInstance!!.iv
        // native.crypto representation = [IV(16) || CIPHERTEXT(n-16)]
        return listOf(iv, bytes)
    }

    override fun decrypt(data: ByteArray, key: ByteArray): ByteArray {
        // javax.crypto representation = [CIPHERTEXT(n-16)]
        val iv: ByteArray = data.take(16).toByteArray()
        val payload: ByteArray = data.drop(16).toByteArray()
        return decryptAsList(listOf(iv, payload), key)
    }

    override fun decryptAsList(data: List<ByteArray>, key: ByteArray): ByteArray {
        if (cipherInstance == null) {
            // native.crypto representation = [IV(16) || CIPHERTEXT(n-16)]
            // javax.crypto representation = [CIPHERTEXT(n-16)]
            cipherInstance = javax.crypto.Cipher.getInstance("AES/CBC/PKCS5Padding")
        }
        val sk = SecretKeySpec(key, "AES")
        val iv: ByteArray = data.first()
        val ivSpec = IvParameterSpec(iv)
        cipherInstance!!.init(javax.crypto.Cipher.DECRYPT_MODE, sk, ivSpec)
        forEncryption = false
        val payload: ByteArray = data.last()
        return cipherInstance!!.doFinal(payload)
    }
}