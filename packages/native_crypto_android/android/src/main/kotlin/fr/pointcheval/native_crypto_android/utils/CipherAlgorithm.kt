package fr.pointcheval.native_crypto_android.utils

import fr.pointcheval.native_crypto_android.ciphers.AES
import fr.pointcheval.native_crypto_android.interfaces.Cipher

enum class CipherAlgorithm {
    aes;

    fun getCipher(): Cipher {
        return when (this) {
            aes -> AES()
        }
    }
}