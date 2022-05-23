package fr.pointcheval.native_crypto_android.ciphers

import fr.pointcheval.native_crypto_android.Cipher
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

class AESCipher : Cipher() {
    override fun encrypt(data: ByteArray, key: ByteArray): ByteArray {
        val sk: SecretKey = SecretKeySpec(key, "AES")
        val cipher = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, sk)
        // javax.crypto representation = [CIPHERTEXT(n-28) || TAG(16)]
        val bytes = cipher.doFinal(data)
        val iv = cipher.iv.copyOf()                                                 // 12 bytes nonce
        // native.crypto representation = [NONCE(12) || CIPHERTEXT(n-28) || TAG(16)]
        return iv.plus(bytes)
    }

    override fun decrypt(data: ByteArray, key: ByteArray): ByteArray? {
        val sk: SecretKey = SecretKeySpec(key, "AES")
        // native.crypto representation = [NONCE(12) || CIPHERTEXT(n-28) || TAG(16)]
        val iv = data.sliceArray(IntRange(0,11))                              // 12 bytes nonce
        // javax.crypto representation = [CIPHERTEXT(n-28) || TAG(16)]
        val payload = data.sliceArray(IntRange(12, data.size - 1))
        val spec = GCMParameterSpec(16 * 8, iv)
        val cipher = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(javax.crypto.Cipher.DECRYPT_MODE, sk, spec)
        return cipher.doFinal(payload)
    }
}