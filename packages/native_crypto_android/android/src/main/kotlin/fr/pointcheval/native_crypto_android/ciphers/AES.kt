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
        val sk: SecretKey = SecretKeySpec(key, "AES")
        val cipher = javax.crypto.Cipher.getInstance("AES/CBC/PKCS5Padding")
        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        // javax.crypto representation = [CIPHERTEXT(n-16)]
        val bytes = cipher.doFinal(data)
        val iv = cipher.iv
        // native.crypto representation = [IV(16) || CIPHERTEXT(n-16)]
        return iv.plus(bytes)
    }

    override fun decrypt(data: ByteArray, key: ByteArray): ByteArray {
        val sk: SecretKey = SecretKeySpec(key, "AES")
        // native.crypto representation = [IV(16) || CIPHERTEXT(n-16)]
        val iv: ByteArray = data.take(16).toByteArray()
        // javax.crypto representation = [CIPHERTEXT(n-16)]
        val payload: ByteArray = data.drop(16).toByteArray()
        val ivSpec = IvParameterSpec(iv)
        val cipher = javax.crypto.Cipher.getInstance("AES/CBC/PKCS5Padding")
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, sk, ivSpec)
        return cipher.doFinal(payload)
    }
}