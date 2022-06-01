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

    var cipherInstance: javax.crypto.Cipher? = null;

    fun lazyLoadCipher() {
        if (cipherInstance == null) {
            cipherInstance = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        }
    }

    // native.crypto cipherText representation = [NONCE(12) || CIPHERTEXT(n-28) || TAG(16)]
    // javax.crypto cipherText representation = [NONCE(12)] + [CIPHERTEXT(n-16) || TAG(16)]
    override fun encrypt(data: ByteArray, key: ByteArray): ByteArray {
        val list : List<ByteArray> = encryptAsList(data, key)
        return list.first().plus(list.last())
    }

    // native.crypto cipherText representation = [NONCE(12)] + [CIPHERTEXT(n-16) || TAG(16)]
    // javax.crypto cipherText representation = [NONCE(12)] + [CIPHERTEXT(n-16) || TAG(16)]
    override fun encryptAsList(data: ByteArray, key: ByteArray): List<ByteArray> {
        val sk = SecretKeySpec(key, "AES")
        lazyLoadCipher()
        cipherInstance!!.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        val bytes: ByteArray = cipherInstance!!.doFinal(data)
        val iv: ByteArray = cipherInstance!!.iv
        return listOf(iv, bytes)
    }

    override fun decrypt(data: ByteArray, key: ByteArray): ByteArray {
        val iv: ByteArray = data.take(12).toByteArray()
        val payload: ByteArray = data.drop(12).toByteArray()
        return decryptAsList(listOf(iv, payload), key)
    }

    override fun decryptAsList(data: List<ByteArray>, key: ByteArray): ByteArray {
        val sk = SecretKeySpec(key, "AES")
        val payload: ByteArray = data.last()
        val iv: ByteArray = data.first()
        val gcmSpec = GCMParameterSpec(16 * 8, iv)
        lazyLoadCipher()
        cipherInstance!!.init(javax.crypto.Cipher.DECRYPT_MODE, sk, gcmSpec)
        return cipherInstance!!.doFinal(payload)
    }
}