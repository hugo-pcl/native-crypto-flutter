package fr.pointcheval.native_crypto_android.keys

import fr.pointcheval.native_crypto_android.interfaces.Key
import java.security.SecureRandom

class SecretKey(override val bytes: ByteArray) : Key {
    companion object {
        fun fromSecureRandom(bitsCount: Int): SecretKey {
            val bytes = ByteArray(bitsCount / 8)
            SecureRandom.getInstanceStrong().nextBytes(bytes)
            return SecretKey(bytes)
        }
    }
}