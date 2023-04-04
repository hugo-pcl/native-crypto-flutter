package fr.pointcheval.native_crypto_android.utils

import fr.pointcheval.native_crypto_android.HashAlgorithm
import java.security.MessageDigest
import javax.crypto.Mac

object HashAlgorithmParser {
    fun getMessageDigest(algorithm: HashAlgorithm): MessageDigest {
        return when (algorithm) {
            HashAlgorithm.SHA256 -> MessageDigest.getInstance("SHA-256")
            HashAlgorithm.SHA384 -> MessageDigest.getInstance("SHA-384")
            HashAlgorithm.SHA512 -> MessageDigest.getInstance("SHA-512")
        }
    }

    fun getMac(algorithm: HashAlgorithm): Mac {
        return when (algorithm) {
            HashAlgorithm.SHA256 -> Mac.getInstance("HmacSHA256")
            HashAlgorithm.SHA384 -> Mac.getInstance("HmacSHA384")
            HashAlgorithm.SHA512 -> Mac.getInstance("HmacSHA512")
        }
    }

    fun getPbkdf2String(algorithm: HashAlgorithm): String {
        return when (algorithm) {
            HashAlgorithm.SHA256 -> "PBKDF2WithHmacSHA256"
            HashAlgorithm.SHA384 -> "PBKDF2WithHmacSHA384"
            HashAlgorithm.SHA512 -> "PBKDF2WithHmacSHA512"
        }
    }
}