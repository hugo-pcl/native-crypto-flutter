package fr.pointcheval.native_crypto_android

import java.security.SecureRandom
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec

object Key {
     fun fromSecureRandom(bitsCount: Int) : ByteArray {
         val bytes = ByteArray(bitsCount / 8)
         SecureRandom.getInstanceStrong().nextBytes(bytes)
         return bytes
     }

    fun fromPBKDF2(password: String, salt: String, keyBytesCount: Int, iterations: Int, algorithm: String): ByteArray {
        val availableHashAlgorithm: Map<String, String> = mapOf(
            "sha256" to "PBKDF2WithHmacSHA256",
            "sha384" to "PBKDF2withHmacSHA384",
            "sha512" to "PBKDF2withHmacSHA512"
        )
        val spec = PBEKeySpec(password.toCharArray(), salt.toByteArray(), iterations, keyBytesCount * 8)
        val skf: SecretKeyFactory = SecretKeyFactory.getInstance(availableHashAlgorithm[algorithm])
        return skf.generateSecret(spec).encoded
    }
}