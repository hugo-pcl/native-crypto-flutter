package fr.pointcheval.native_crypto

import android.os.Build
import java.lang.IllegalArgumentException
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec

class KeyDerivation {
    fun pbkdf2(password: String, salt: String, keyLength: Int, iteration: Int, algorithm: String): ByteArray {
        val chars: CharArray = password.toCharArray()
        val availableHashAlgorithm: Map<String, String> = mapOf(
                "sha1" to "PBKDF2withHmacSHA1",
                "sha224" to "PBKDF2withHmacSHA224",
                "sha256" to "PBKDF2WithHmacSHA256",
                "sha384" to "PBKDF2withHmacSHA384",
                "sha512" to "PBKDF2withHmacSHA512"
        )

        if (Build.VERSION.SDK_INT >= 26) {
            // SHA-1 and SHA-2 implemented
            val spec = PBEKeySpec(chars, salt.toByteArray(), iteration, keyLength * 8)
            val skf: SecretKeyFactory = SecretKeyFactory.getInstance(availableHashAlgorithm[algorithm]);
            return skf.generateSecret(spec).encoded
        } else if (Build.VERSION.SDK_INT >= 10) {
            // Only SHA-1 is implemented
            if (!algorithm.equals("sha1")) {
                throw PlatformVersionException("Only SHA1 is implemented on this SDK version!")
            }
            val spec = PBEKeySpec(chars, salt.toByteArray(), iteration, keyLength * 8)
            val skf: SecretKeyFactory = SecretKeyFactory.getInstance("PBKDF2withHmacSHA1");
            return skf.generateSecret(spec).encoded
        }
        throw PlatformVersionException("Invalid SDK version!")
    }
}